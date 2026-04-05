{
  flake.modules.nixos.base-networking =
    { pkgs, ... }:
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
      };

      environment.systemPackages = [ pkgs.ethtool ];
    };
}
