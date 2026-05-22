{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      lib,
      ...
    }:
    let
      xlm = pkgs.callPackage (
        # from https://github.com/Blooym/xlm/issues/27#issuecomment-2925634085
        {
          lib,
          rustPlatform,
          fetchFromGitHub,
          pkg-config,
          libxkbcommon,
          wayland,
          libGL,
          # not sure vulkan-loader is actually needed
          vulkan-loader,
        }:
        let
          # as a steam compatibility tool it runs inside steam's FHSEnv, using steam-run breaks it
          xl-no-steam-run = inputs.self.packages.${system}.xivlauncher-rb;
        in
        rustPlatform.buildRustPackage rec {
          pname = "xlm";
          version = "0.4.0";

          src = fetchFromGitHub {
            owner = "Blooym";
            repo = "XLM";
            rev = "v${version}";
            hash = "sha256-Awb/16ddPxNXNdrXGpnkDDWwd3pQLuMk0m13pqo35JM=";
          };

          # the only feature is a self-updater
          buildNoDefaultFeatures = true;

          cargoHash = "sha256-HMWQPqSwNgYxxMGnNmxSVAX2xxbVw5Wdj80w2zMLzug=";

          outputs = [
            "out"
            "steamcompattool"
          ];

          nativeBuildInputs = [ pkg-config ];

          buildInputs = [
            libxkbcommon
            wayland
            vulkan-loader
            libGL
          ];

          # needed for winit to behave
          postFixup = ''
            patchelf $out/bin/${pname} \
              --add-rpath ${
                lib.makeLibraryPath [
                  libxkbcommon
                  wayland
                  libGL
                ]
              }
          '';

          postInstall = ''
            xlcore_install_dir=$steamcompattool/xlcore
            mkdir -p $xlcore_install_dir

            echo ${xl-no-steam-run.version} > $xlcore_install_dir/versiondata
            ln -sfn ${lib.getExe xl-no-steam-run} $xlcore_install_dir/

            $out/bin/xlm install-steam-tool \
            --extra-launch-args="\
              --xlcore-repo-owner rankynbass \
              --run-as-steam-compat-tool=true \
              --skip-update" \
            --steam-compat-path $TMPDIR/

            sed -i 's/XLCore/XLCore-RB/' $TMPDIR/XLM/compatibilitytool.vdf
            sed -i 's/"xlm"/"xlm-rb"/' $TMPDIR/XLM/compatibilitytool.vdf
            sed -i 's/"xlm"/"xlm-rb"/' $TMPDIR/XLM/toolmanifest.vdf

            mv $TMPDIR/XLM/* $steamcompattool
            ln -sfn $out/bin/${meta.mainProgram} $steamcompattool/
          '';

          meta = {
            description = "A painless XIVLauncher on Linux/Steam Deck experience. Automatic updater & Steam Compatibility Tool (RB version)";
            homepage = "https://github.com/Blooym/XLM";
            license = lib.licenses.agpl3Only;
            mainProgram = "xlm";
            platforms = lib.platforms.linux;
          };
        }
      ) { };
    in
    lib.optionalAttrs (system == "x86_64-linux") { packages.xlm = xlm; };
}
