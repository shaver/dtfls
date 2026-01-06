{
  flake.modules.nixos.base-networking = {
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
  };
}
