{ config, ... }:
{
  flake.modules.nixos.shaver-personal =
    { inputs, ... }:
    {
      imports = [ config.flake.modules.nixos.shaver-base ];
      home-manager.users.shaver = {
        imports = [
          config.flake.modules.homeManager.shaver-personal
        ];
      };

      users.users.shaver.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBomlNnFJeNurNUx2v3ciKKfUDXkHI17KFpzj7wUcYrE shaver@shaverbook.local"
      ];

    };
}
