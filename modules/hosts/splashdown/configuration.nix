{ inputs, ... }: {
  flake.modules.nixos.splashdown = { pkgs, ... }: {
    imports = [
      inputs.determinate.nixosModules.default
      inputs.sops-nix.nixosModules.sops
    ] ++ (with inputs.self.modules.nixos; [
      base-system
      base-networking
      gaming
      desktop-audio
      desktop
      shaver-personal-desktop
      nvidia-hardware
      shaver-personal
      sunshine
    ]) ++ (with inputs.self.commonModules; [ sudo nix ]);

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
