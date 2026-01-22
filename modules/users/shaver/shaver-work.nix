{ config, ... }:
{
  flake.modules.darwin.shaver-work = {
    imports = with config.flake.modules.darwin; [
      shaver-base
      aerospace
      homebrew
    ];

    home-manager.users.shaver = {
      imports = with config.flake.modules.homeManager; [
        shaver-work-darwin
      ];
    };
  };
}
