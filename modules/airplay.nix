{
  flake.modules.nixos.airplay-server = {
    services.shairport-sync = {
      enable = true;
      openFirewall = true;
      settings = {
        general = {
          output_backend = "alsa";
          volume_range_db = 30;
        };
        alsa = {
          output_device = "hw:CARD=Wireless,DEV=1"; # FIXME: per-host setting!
        };
        diagnostics.log_verbosity = "3";
        sessioncontrol.allow_session_interruption = "yes";
      };
    };

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  flake.modules.nixos.airplay-client = {
    services.avahi.enable = true;
    services.pipewire = {
      raopOpenFirewall = true;
      extraConfig.pipewire = {
        "10-airplay" = {
          "context.modules" = [ { name = "libpipewire-module-raop-discover"; } ];
        };
      };
    };
  };
}
