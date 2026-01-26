{
  flake.modules.nixos.outpost-arm64 = {
    boot.loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/510A-952D";
      fsType = "vfat";
    };
    boot.initrd.availableKernelModules =
      [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
    boot.initrd.kernelModules = [ "nvme" ];
    fileSystems."/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
  };
}
