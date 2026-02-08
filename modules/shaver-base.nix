{ inputs, ... }: {
  # Common module for shaver user. Configurations should include
  # shaver-personal or shaver-work rather than including shaver-base
  # directly.
  flake.modules.nixos.shaver-base = { pkgs, ... }: {
    # wire up basic user configuration
    users.users.shaver = {
      isNormalUser = true;
      description = "Mike Shaver";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
    programs.firefox.enable = true;

    # bring in Home Manager
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "hmbckp";
      sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
    };
  };

  flake.modules.darwin.shaver-base = {

    programs.zsh.enable = true;

    # bring in Home Manager
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "hmbckp";
    };
  };

  flake.modules.homeManager.shaver-base = { config, pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [
      git
      neovim
      shell
      ssh
      tmux
    ];

    home = {
      username = "shaver";
      homeDirectory =
        if pkgs.stdenv.isDarwin then "/Users/shaver" else "/home/shaver";
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

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
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
      nixfmt-rfc-style

      jq
      curl
      coreutils

      # Fonts
      nerd-fonts.meslo-lg
      nerd-fonts.jetbrains-mono
      font-awesome
    ];
  };
}
