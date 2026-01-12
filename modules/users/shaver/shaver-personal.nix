{ config, ... }:
{
  flake.modules.nixos.shaver-personal-desktop = {
    imports = [ config.flake.modules.nixos.shaver-personal ];
    home-manager.users.shaver = {
      imports = with config.flake.modules.homeManager; [
        shaver-3d-printing
        shaver-personal-nixos-desktop
      ];
    };
  };
  flake.modules.nixos.shaver-personal = {
    imports = [ config.flake.modules.nixos.shaver-base ];
    home-manager.users.shaver = {
      imports = with config.flake.modules.homeManager; [ shaver-personal-nixos ];
    };

    users.users.shaver.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBomlNnFJeNurNUx2v3ciKKfUDXkHI17KFpzj7wUcYrE shaver@shaverbook.local"
    ];

  };

  flake.modules.darwin.shaver-personal = {
    imports = with config.flake.modules.darwin; [
      shaver-base
      aerospace
      homebrew
    ];

    home-manager.users.shaver = {
      imports = with config.flake.modules.homeManager; [ shaver-personal-darwin ];
    };

    users.users.shaver.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBomlNnFJeNurNUx2v3ciKKfUDXkHI17KFpzj7wUcYrE shaver@shaverbook.local"
    ];

  };
}
