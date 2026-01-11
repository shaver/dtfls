{ config, ... }: {
  flake.modules.nixos.nvidia-hardware = { config, ... }: {
    hardware.graphics.enable = true; # enable OpenGL
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true; # open-source NVIDIA kernel module (not "nouveau"!)
      nvidiaSettings = true;
    };
  };
}
