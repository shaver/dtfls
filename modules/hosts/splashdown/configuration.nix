{ inputs, ... }:
{
  flake.modules.nixos.splashdown = {
    imports = with inputs.self.modules.nixos; [
      gaming
      desktop-audio
      desktop
      shaver-personal-desktop
      nvidia-hardware
      shaver-personal
      ollama
      bluetooth
      yubikey
      moonshine-and-buddy # headless game streaming
    ];

    # disable the extraneous audio outputs
    services.pipewire.wireplumber.extraConfig = {
      "disable-bullshit-outputs" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "device.name" = "alsa_card.pci-0000_01_00.1"; }
              { "device.name" = "alsa_card.usb-Generic_USB_Audio-00"; }
              { "device.name" = "alsa_card.pci-0000_14_00.1"; }
            ];
            actions = {
              update-props = {
                "device.disabled" = "true";
              };
            };
          }
          {
            matches = [
              { "node.name" = "alsa_output.usb-Shure_Inc_Shure_MV7-00.analog-stereo"; }
            ];
            actions = {
              update-props = {
                "node.disabled" = "true";
              };
            };
          }
        ];
      };
    };

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
      pi-coding-agent
      haskell
    ];
  };
}
