{ config, inputs, ... }: {
  flake.modules.nixos.splashdown = { pkgs, ... }: {
    imports = [ inputs.determinate.nixosModules.default ]
      ++ (with config.flake.modules.nixos; [
        base-system
        base-networking
        gaming
        desktop-audio
        nix
        desktop
        shaver-personal
        nvidia-hardware
      ]) ++ (with config.flake.commonModules; [ sudo ]);

    powerManagement.enable = true;
    # sleep crashes this machine, so let's just not
    systemd.sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';

  };
}
