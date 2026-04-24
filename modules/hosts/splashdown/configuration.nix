{ inputs, ... }:
{
  flake.modules.nixos.splashdown =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
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

      flake.dtfls.opts.form = "desktop";

      # disable ASPM due to problem with igc network driver (I225, motherboard)
      boot.kernelParams = [
        "pcie_port_pm=off"
        "pcie_aspm.policy=performance"
      ];

      # sleep crashes this machine, so let's just not
      systemd.sleep.settings.Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
        AllowHybridSleep = "no";
        AllowSuspendThenHibernate = "no";
      };

    };
}
