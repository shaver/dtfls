{
  flake.modules.nixos.base-networking = { pkgs, ... }: {
    services.resolved = {
      enable = true;
      domains = [ "local" ];
      llmnr = "false";
      extraConfig = ''
        MulticastDNS=true
      '';
    };

    networking = {
      networkmanager.enable = true;
      # firewall interferes with mDNS. TODO: narrower exemption?
      firewall.enable = false;
    };

    environment.systemPackages = [ pkgs.ethtool ];
  };
}
