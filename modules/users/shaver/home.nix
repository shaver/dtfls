{
  inputs,
  ...
}:
{
  flake.modules.homeManager.shaver =
    let
      homeDirectory = "/home/shaver";
      configRepo = "${homeDirectory}/dtfls";
    in
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        git
      ];
      home = {
        username = "shaver";
        inherit homeDirectory;
        stateVersion = "25.11";
      };

      programs = {
        direnv.nix-direnv.enable = true;

        zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
        };

        fzf = {
          enable = true;
          enableZshIntegration = true;
        };

        # Type `z <pat>` to cd to some directory
        zoxide.enable = true;

        # Better shell prompt!
        starship = {
          enable = true;
          settings = {
            username = {
              style_user = "blue bold";
              style_root = "red bold";
              format = "[$user]($style) ";
              disabled = false;
              show_always = true;
            };
            hostname = {
              ssh_only = false;
              ssh_symbol = "🌐 ";
              format = "on [$hostname](bold red) ";
              trim_at = ".local";
              disabled = false;
            };
          };
        };

        neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
          withNodeJs = true;
          withPython3 = true;
          extraPackages = with pkgs; [
            go
            python3
            luarocks
            tree-sitter
            imagemagick
            tectonic
            ghostscript
            mermaid-cli
            statix
            cargo
            unzip
            gcc
          ];
        };
      };

      # use the "raw" nvim config from this repo
      xdg.configFile = {
        nvim = {
          source = config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/nvim";
          recursive = true;
        };
      };

      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        # Unix tools
        ripgrep # Better `grep`
        fd
        sd
        tree
        gnumake

        clang

        # Nix dev
        cachix
        nil # Nix language server
        nix-info
        nixpkgs-fmt
        nixfmt-rfc-style
        nh

        jq
        curl
        coreutils

        # Fonts
        nerd-fonts.meslo-lg
        nerd-fonts.jetbrains-mono

        # for jj
        meld

        # for niri
        fuzzel
        alacritty
        hyprlock
        xwayland-satellite
      ];

      programs.ssh.matchBlocks."*".addKeysToAgent = "yes";

      services.ssh-agent = {
        enable = true;
        enableZshIntegration = true;
      };

    };
}
