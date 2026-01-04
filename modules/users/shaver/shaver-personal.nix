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
    };
}
