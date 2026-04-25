{
  flake.modules.nixos.bluetooth =
    { config, pkgs, ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            experimental = true;
            # https://old.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax
            # for pairing bluetooth controller
            Privacy = "device";
            JustWorksRepairing = "always";
            Class = "0x000100";
            FastConnectable = true;
          };
          Policy = {
            AutoEnable = true;
          };
        };
        package = pkgs.bluez-experimental;
      };

      services.blueman.enable = true;

      hardware.xpadneo.enable = true; # for xbox one wireless controller
      boot = {
        extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
        extraModprobeConfig = ''
          options bluetooth disable_ertm=Y
        '';
        # connect xbox controller
      };
    };
}
