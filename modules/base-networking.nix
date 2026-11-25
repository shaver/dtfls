{ inputs, ... }: {
  flake.modules.nixos.base-networking =
    { pkgs, lib, ... }:
    {
      services.resolved = {
        enable = true;
        settings.Resolve = {
          Domains = [ "local" ];
          # MulticastDNS = true;
        };
      };

      networking = {
        networkmanager = {
          enable = true;
          connectionConfig = {
            "connection.mdns" = 1;
          };
        };
        # firewall interferes with mDNS. TODO: narrower exemption?
        firewall.enable = false;
      };

      services.tailscale = {
        enable = true;
        package = lib.mkDefault inputs.tailscale.packages.${pkgs.stdenv.hostPlatform.system}.tailscale;
      };

      environment.systemPackages = [ pkgs.ethtool ];
    };
}
