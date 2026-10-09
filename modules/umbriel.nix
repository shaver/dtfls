{ inputs, ... }:
{
  flake.modules.hjem.umbriel =
    { config, pkgs, ... }:
    let
      configRepo = "${config.directory}/dtfls";
    in
    {
      packages = with pkgs; [
        xwayland-satellite
        playerctl
      ];

      xdg.config.files.umbriel.source = "${configRepo}/config/umbriel";
    };

  flake.modules.nixos.umbriel = {
    imports = [ inputs.umbriel.nixosModules.default ];
    programs.umbriel.enable = true;
  };
}
