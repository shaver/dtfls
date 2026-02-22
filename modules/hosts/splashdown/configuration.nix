{ inputs, ... }: {
  flake.modules.nixos.splashdown = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      base-system
      gaming
      desktop-audio
      desktop
      shaver-personal-desktop
      nvidia-hardware
      shaver-personal
      sunshine
      # testing-kernel
    ];

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
