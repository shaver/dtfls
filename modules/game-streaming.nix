{ inputs, ... }: {

  flake.modules.nixos.moonshine-and-buddy =
    { pkgs, ... }:
    let
      inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) moondeck-buddy;
    in
    {
      environment.systemPackages = [ moondeck-buddy ];

      # let moonshine inject events from the client
      hardware.uinput.enable = true;

      users.users.shaver.extraGroups = [
        "moonshine" # put in a moonshine.nix?
        "input"
        "uinput"
      ];

      # moonlight discovery
      services.avahi = {
        enable = true;
        publish.enable = true;
        publish.userServices = true;
      };

      services.moonshine = {
        enable = true;
        user = "shaver";
        openFirewall = true;

        settings = {
          application = [
            {
              # moonshine defaults to /usr/bin/steam
              title = "Steam";
              command = [
                "/run/current-system/sw/bin/steam"
                "steam://open/bigpicture"
              ];
            }

            {
              title = "MoonDeckStream";
              command = [
                "/run/current-system/sw/bin/MoonDeckStream"
              ];
            }
          ];

          application_scanner = [
            {
              type = "steam";
              library = "$HOME/.local/share/Steam";
              command = [
                "/run/current-system/sw/bin/steam"
                "-bigpicture"
                "steam://rungameid/{game_id}"
              ];
            }
          ];
        };
      };

    };

}
