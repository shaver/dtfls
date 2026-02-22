{
  flake.modules.nixos.testing-kernel = { pkgs, lib, ... }: {
    boot.kernelPackages = lib.mkForce (let
      git_kernel_package = { buildLinux, ... }@args:
        buildLinux (args // rec {
          version = "7.0rc1";
          modDirVersion = version;

          src = pkgs.fetchurl {
            url =
              "https://github.com/torvalds/linux/archive/refs/tags/v7.0-rc1.tar.gz";
            hash = "sha256-bWsr0T/pXqSMSQHKW0Ueu8U2xjAQSdH7cFaNXYdWqts=";
          };
          kernelPatches = [ ];
          extraMeta.branch = "7.0";
        } // (args.argsOverride or { }));
      linux_git = pkgs.callPackage git_kernel_package { };
    in lib.recurseIntoAttrs (pkgs.linuxPackagesFor linux_git));
  };
}
