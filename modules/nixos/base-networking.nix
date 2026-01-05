{
  flake.modules.nixos.base-networking = {
    services.avahi = {
      enable = true;
      nssmdns4 = true; # leave `nssmdns6` disabled to avoid timeouts
    };

    networking.networkmanager.enable = true;
  };
}
