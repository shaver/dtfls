{
  inputs,
  ...
}:
{
  flake.modules.homeManager.shaver =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        git
        neovim
        shell
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

        irssi = {
          enable = true;
          networks.sizone = {
            server = {
              address = "irc.sizone.org";
              autoConnect = true;
            };
            nick = "shaver";
            channels."#tek".autoJoin = true;
          };
        };

        tmux = {
          enable = true;
          shortcut = "a";
        };

        nh = {
          enable = true;
          clean.enable = true;
          flake = "${config.home.homeDirectory}/dtfls"; # default for "os switch"
        };

        htop.enable = true;
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
