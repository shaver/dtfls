{ inputs, ... }: {

  flake.modules.nixos.moonshine-and-buddy =
    { pkgs, ... }:
    let
      inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) moondeck-buddy;
    in
    {
      # MoonDeckStream must stay in the system profile: moonshine launches it
      # via /run/current-system/sw/bin/MoonDeckStream
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
        settings.publish = {
          disable-publishing = false;
          disable-user-service-publishing = false;
          publish-addresses = true;
        };
      };

      services.moonshine = {
        enable = true;
        user = "shaver";
        firewallInterfaces = [
          "tailscale0"
          "enp6s0"
        ]; # XXX TODO splashdown

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
