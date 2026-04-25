{
  flake.modules.nixos.nvidia-hardware =
    { config, lib, ... }:
    let
      inherit (lib) mkDefault;
    in
    {
      hardware.graphics.enable = true; # enable OpenGL
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true; # open-source NVIDIA kernel module (not "nouveau"!)
        nvidiaSettings = true;
      };

      # don't compile the CUDA stuff if we don't have to
      nix.settings = {
        extra-substituters = [ "https://cache.nixos-cuda.org" ];
        extra-trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
      };
    };
}
