{
  flake.modules.nixos.nvidia-hardware =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkDefault;
    in
    {
      hardware.graphics.enable = true; # enable OpenGL
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.latest;
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true; # open-source NVIDIA kernel module (not "nouveau"!)
        nvidiaSettings = true;
      };

      environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];

      # don't compile the CUDA stuff if we don't have to
      # TURNS OUT that this cache is slow as shit so it's faster to build ourselves
      # nix.settings = {
      #   extra-substituters = [ "https://cache.nixos-cuda.org" ];
      #   extra-trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
      # };
    };

  # Returns a NixOS module that sets the GPU power limit at boot, either as a
  # percentage of each GPU's default limit or as an absolute wattage (not both):
  #   imports = [ (inputs.self.lib.nvidia-power-limit { watts = 360; }) ];
  # With neither given, defaults to 80% of the default limit.
  # (Lives in flake.lib rather than flake.modules.nixos because the latter
  # would treat the function as a module and call it with module args.)
  flake.lib.nvidia-power-limit =
    {
      percent ? null,
      watts ? null,
    }:
    if percent != null && watts != null then
      throw "nvidia-power-limit: pass either `percent` or `watts`, not both."
    else
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        nvidia-smi = lib.getExe' config.hardware.nvidia.package.bin "nvidia-smi";

        useWatts = watts != null;
        pct = if percent != null then percent else 80;
        summary = if useWatts then "${toString watts}W" else "${toString pct}% of default";
        computeLimit =
          if useWatts then
            "limit_w=${toString watts}"
          else
            "limit_w=$(( \${default_w%.*} * ${toString pct} / 100 ))";

        setPowerLimit = pkgs.writeShellApplication {
          name = "nvidia-set-power-limit";
          runtimeInputs = [ pkgs.coreutils ];
          text = ''
            # set each GPU's power limit to ${summary}
            ${nvidia-smi} --query-gpu=index,power.default_limit --format=csv,noheader,nounits |
              while IFS=', ' read -r idx default_w; do
                ${computeLimit}
                echo "GPU $idx: default ''${default_w}W -> ''${limit_w}W"
                ${nvidia-smi} -i "$idx" -pl "$limit_w"
              done
          '';
        };
      in
      {
        systemd.services.nvidia-power-limit = {
          description = "Set NVIDIA GPU power limit to ${summary}";
          wantedBy = [ "multi-user.target" ];
          after = [ "systemd-modules-load.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = lib.getExe setPowerLimit;
          };
        };
      };
}
