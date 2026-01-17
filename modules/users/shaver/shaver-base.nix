{ inputs, ... }: {
  # Common module for shaver user. Configurations should include
  # shaver-personal or shaver-work rather than including shaver-base
  # directly.
  flake.modules.nixos.shaver-base = { lib, config, pkgs, ... }: {
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

  flake.modules.darwin.shaver-base = { lib, config, pkgs, ... }: {

    programs.zsh.enable = true;

    # bring in Home Manager
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager.backupFileExtension = "hmbckp";
  };
}
