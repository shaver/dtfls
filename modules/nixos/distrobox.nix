{
  # Distrobox support, configured as per https://wiki.nixos.org/wiki/Distrobox
  flake.modules.nixos.distrobox =
    { pkgs, ... }:
    {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };

      environment = {
        systemPackages = [ pkgs.distrobox ];
        etc."distrobox/distrobox.conf".text = ''
          container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
        '';
      };

      users.users.shaver = {
        extraGroups = [ "podman" ];
        subGidRanges = [
          {
            count = 65536;
            startGid = 1000;
          }
        ];
        subUidRanges = [
          {
            count = 65536;
            startUid = 1000;
          }
        ];
      };

    };

}
