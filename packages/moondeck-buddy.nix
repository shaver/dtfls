{
  perSystem =
    {
      pkgs,
      system,
      lib,
      ...
    }:
    let
      moondeck-buddy = pkgs.callPackage (
        # from https://github.com/MysticalPvE/nixos2026/blob/707852d3d4730ca76ea74605aa77c6b66cf8ef9c/packages/moondeck-buddy/default.nix
        {
          lib,
          stdenv,
          fetchFromGitHub,
          nix-update-script,
          kdePackages,
          cmake,
          ninja,
          qt6,
          procps,
          libxrandr,
        }:
        let
          inherit (kdePackages) qtbase wrapQtAppsHook;
          qtEnv =
            with qt6;
            env "qt-env-custom-${qtbase.version}" [
              qthttpserver
              qtwebsockets
            ];
        in
        stdenv.mkDerivation (finalAttrs: {
          pname = "moondeck-buddy";
          version = "1.9.2";

          src = fetchFromGitHub {
            owner = "FrogTheFrog";
            repo = "moondeck-buddy";
            tag = "v${finalAttrs.version}";
            fetchSubmodules = true;
            hash = "sha256-GhZlmdI+oa5BjEzr9bkR2sY/nVpd1nuJlT2hYYv6zGU=";
          };

          buildInputs = [
            procps
            libxrandr
            qtbase
            qtEnv
          ];
          nativeBuildInputs = [
            cmake
            ninja
            wrapQtAppsHook
          ];

          passthru.updateScript = nix-update-script { };
          meta = {
            mainProgram = "MoonDeckBuddy";
            description = "Helper to work with Moonlight on a Steam Deck";
            homepage = "https://github.com/FrogTheFrog/moondeck-buddy";
            changelog = "https://github.com/FrogTheFrog/moondeck-buddy/releases/tag/v${finalAttrs.version}";
            license = lib.licenses.lgpl3Only;
            maintainers = [ lib.maintainers.redxtech ];
            platforms = lib.platforms.linux;
          };
        })
      ) { };
    in
    lib.optionalAttrs (system == "x86_64-linux") { packages.moondeck-buddy = moondeck-buddy; };
}
