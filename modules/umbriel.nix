{ inputs, ... }:
{
  flake.modules.homeManager.umbriel =
    { config, pkgs, ... }:
    let
      configRepo = "${config.home.homeDirectory}/dtfls";
    in
    {
      home.packages = with pkgs; [
        xwayland-satellite
        playerctl
      ];

      xdg.configFile = {
        umbriel = {
          source = config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/umbriel";
          recursive = true;
        };
      };
    };

  flake.modules.nixos.umbriel = {
    imports = [ inputs.umbriel.nixosModules.default ];
    programs.umbriel.enable = true;
  };
}
