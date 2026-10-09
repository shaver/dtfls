{ inputs, ... }:
let
  # hjem wiring shared by nixos and darwin
  hjemFor =
    { config, ... }:
    {
      hjem = {
        # hjem refuses to replace existing files by default; the targets were
        # previously home-manager symlinks into the store
        clobberByDefault = true;
        extraModules = [
          inputs.hjem-rum.hjemModules.default
          inputs.self.modules.hjem.nix
          inputs.self.modules.hjem."host-${config.networking.hostName}-shaver"
        ];
      };
    };

  desktopFonts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      fonts.packages = lib.optionals (config.flake.dtfls.opts.form == "desktop") (
        with pkgs;
        [
          nerd-fonts.meslo-lg
          nerd-fonts.jetbrains-mono
          font-awesome
          noto-fonts
        ]
      );
    };
in
{
  # Common module for shaver user. Configurations should include
  # shaver-personal or shaver-work rather than including shaver-base
  # directly.
  flake.modules.nixos.shaver-base =
    { pkgs, config, ... }:
    {
      # wire up basic user configuration
      users.users.shaver = {
        isNormalUser = true;
        description = "Mike Shaver";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.zsh;
        uid = 1000;
      };

      programs.zsh.enable = true;
      programs.firefox.enable = config.flake.dtfls.opts.form == "desktop";

      # TODO put this with other nix stuff somehow
      programs.nh = {
        enable = true;
        clean.enable = true;
        flake = "/home/shaver/dtfls"; # default for "os switch"
      };

      # plain ssh-agent at $XDG_RUNTIME_DIR/ssh-agent, rather than the gcr
      # one that niri pulls in
      programs.ssh.startAgent = true;
      services.gnome.gcr-ssh-agent.enable = false;

      # bring in hjem
      imports = [
        inputs.hjem.nixosModules.default
        hjemFor
        desktopFonts
      ];
    };

  flake.modules.darwin.shaver-base = {
    programs.zsh.enable = true;

    # bring in hjem
    imports = [
      inputs.hjem.darwinModules.default
      hjemFor
      desktopFonts
    ];
  };

  flake.modules.hjem.shaver-base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = with inputs.self.modules.hjem; [
        git
        nvf
        shell
        ssh
        tmux
      ];

      environment.sessionVariables.NH_FLAKE = "${config.directory}/dtfls";

      # gh writes its own state to hosts.yml, so only config.yml is managed
      xdg.config.files."gh/config.yml" = {
        generator = (pkgs.formats.yaml { }).generate "gh-config.yml";
        value = {
          version = "1";
          git_protocol = "https";
          extensions = [ "yusukebe/gh-markdown-preview" ];
        };
      };

      rum.programs.git.settings.credential =
        lib.genAttrs [ "https://github.com" "https://gist.github.com" ]
          (_: {
            helper = [
              ""
              "${lib.getExe pkgs.gh} auth git-credential"
            ];
          });

      packages =
        with pkgs;
        [
          bat
          jq
          btop
          htop
          nh
          gh
          gh-dash

          # Unix tools
          ripgrep # Better `grep`
          fd
          sd
          tree
          less
          coreutils

          gnumake
          clang

          # Nix dev
          nil # Nix language server
          nix-info
          nixpkgs-fmt
          nixfmt

          curl
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.darwin.libresolv ];
    };
}
