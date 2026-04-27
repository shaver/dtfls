{ inputs, ... }:
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
      };

      programs.zsh.enable = true;
      programs.firefox.enable = config.flake.dtfls.opts.form == "desktop";

      # bring in Home Manager
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "hmbckp";
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.self.modules.homeManager."host-${config.networking.hostName}-shaver"
        ];
      };
    };

  flake.modules.darwin.shaver-base =
    { config, ... }:
    {
      programs.zsh.enable = true;

      # bring in Home Manager
      imports = [ inputs.home-manager.darwinModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "hmbckp";
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.self.modules.homeManager."host-${config.networking.hostName}-shaver"
        ];
      };
    };

  flake.modules.homeManager.shaver-base =
    {
      config,
      pkgs,
      osConfig,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        git
        nvf
        shell
        ssh
        tmux
      ];

      home = {
        username = "shaver";
        homeDirectory = if pkgs.stdenv.isDarwin then "/Users/shaver" else "/home/shaver";
        stateVersion = "25.11";
      };

      programs = {
        bat.enable = true;
        jq.enable = true;
        btop.enable = true;
        htop.enable = true;

        # TODO put this with other nix stuff somehow
        nh = {
          enable = true;
          clean.enable = true;
          flake = "${config.home.homeDirectory}/dtfls"; # default for "os switch"
        };

        gh = {
          enable = true;
          settings.git_protocol = "https";
          settings.extensions = [ "yusukebe/gh-markdown-preview" ];
        };
        gh-dash.enable = true;

      };

      fonts.fontconfig.enable = osConfig.flake.dtfls.opts.form == "desktop";

      home.packages =
        with pkgs;
        [
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
          cachix
          nil # Nix language server
          nix-info
          nixpkgs-fmt
          nixfmt

          jq
          curl
          coreutils

        ]
        ++ lib.optionals (osConfig.flake.dtfls.opts.form == "desktop") (
          with pkgs;
          [
            nerd-fonts.meslo-lg
            nerd-fonts.jetbrains-mono
            font-awesome
          ]
        );
    };
}
