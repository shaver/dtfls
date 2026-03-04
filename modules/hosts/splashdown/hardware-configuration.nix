{
  flake.modules.nixos.splashdown =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot = {
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
        };

        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/3a6ecc9d-2827-4ae5-84d9-e9f9f5d2af91";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/C0B4-5C1A";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
