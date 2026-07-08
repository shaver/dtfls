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
        ollama
        bluetooth
        yubikey
      ];

      powerManagement.enable = true;

      flake.dtfls.opts.form = "desktop";

      # disable ASPM due to problem with igc network driver (I225, motherboard)
      boot.kernelParams = [
        "pcie_port_pm=off"
        "pcie_aspm.policy=performance"
      ];

      # put in a printing module once I get the declarative printer config sorted
      services.printing.enable = true;

      # sleep crashes this machine, so let's just not
      systemd.sleep.settings.Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
        AllowHybridSleep = "no";
        AllowSuspendThenHibernate = "no";
      };
    };

  flake.modules.homeManager.host-splashdown-shaver = {
    imports = with inputs.self.modules.homeManager; [
      shaver-3d-printing
      gaming
      claude-code
      haskell
    ];
  };
}
