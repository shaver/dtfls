{

  flake.modules.nixos.outpost-arm64 = { lib, ... }: {
    # This file was populated at runtime with the networking
    # details gathered from the active system.
    networking = {
      nameservers = [ "8.8.8.8" ];
      defaultGateway = "172.31.1.1";
      defaultGateway6 = {
        address = "fe80::1";
        interface = "eth0";
      };
      dhcpcd.enable = false;
      usePredictableInterfaceNames = lib.mkForce false;
      interfaces = {
        eth0 = {
          ipv4.addresses = [{
            address = "91.99.50.237";
            prefixLength = 32;
          }];
          ipv6.addresses = [
            {
              address = "2a01:4f8:1c1a:c252::1";
              prefixLength = 64;
            }
            {
              address = "fe80::9400:4ff:fe4d:2b2e";
              prefixLength = 64;
            }
          ];
          ipv4.routes = [{
            address = "172.31.1.1";
            prefixLength = 32;
          }];
          ipv6.routes = [{
            address = "fe80::1";
            prefixLength = 128;
          }];
        };

      };
    };
    services.udev.extraRules = ''
      ATTR{address}=="96:00:04:4d:2b:2e", NAME="eth0"

    '';
  };
}
