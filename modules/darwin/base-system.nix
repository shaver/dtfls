{ config, ... }:
{
  flake.modules.darwin.base-system =
    { pkgs, lib, ... }:
    {
      imports = [ ];

      users.users.shaver = {
        name = "shaver";
        home = "/Users/shaver";
      };

      programs.zsh.enable = true;
      # Set your time zone.
      time.timeZone = "America/Toronto";

      services.openssh.enable = lib.mkDefault true;

      security.pam.services.sudo_local.touchIdAuth = true; # Use TouchID for `sudo` authentication

      # condition this on use of detsys nix?
      nix.enable = false; # conflicts with Determinate

      # These users can add Nix caches.
      nix.settings.trusted-users = [
        "root"
        "shaver"
      ];
      ids.gids.nixbld = 350;

      environment = {
        systemPackages = with pkgs; [
          git # for flake management
          pam-watchid
          coreutils # for GNU ls mostly
        ];
        shells = [ pkgs.zsh ];

        # have to force this config globally, see
        # https://stackoverflow.com/questions/79371917/direnv-printing-environment-diff-even-with-hide-env-diff-true/79543570#79543570
        etc."direnv/direnv.toml".text = ''
          [global]
          hide_env_diff = true
        '';
      };

      # Configure macOS system
      # More examples => https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix
      system = {
        defaults = {
          dock = {
            autohide = true;
            expose-group-apps = true; # group apps in Exposé
            magnification = true; # magnify icon on hover
            mru-spaces = false; # don't rearrange spaces based on use
            # customize Hot Corners
            # wvous-tl-corner = 2; # top-left - Mission Control
            # wvous-tr-corner = 13; # top-right - Lock Screen
            # wvous-bl-corner = 3; # bottom-left - Application Windows
            # wvous-br-corner = 4; # bottom-right - Desktop
          };

          finder = {
            _FXShowPosixPathInTitle = true; # show full path in finder title
            AppleShowAllExtensions = true; # show all file extensions
            AppleShowAllFiles = true; # show hidden files
            FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
            NewWindowTarget = "Home"; # default Finder window folder
            FXPreferredViewStyle = "clmv"; # default to column view
            QuitMenuItem = true; # enable quit menu item
            ShowPathbar = true; # show path bar
            ShowStatusBar = true; # show status bar
          };

          CustomUserPreferences = {
            #        "com.apple.Safari" = {
            #          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
            #          "ShowFullURLInSmartSearchField" = true;
            #        };
            "com.apple.TextEdit".RichText = false; # plain text files by default

            NSGlobalDomain = {
              NSAutomaticCapitalizationEnabled = false;
              NSAutomaticSpellingCorrectionEnabled = false;
              AppleInterfaceStyleSwitchesAutomatically = true; # light/dark auto
              # swipe left/right doesn't navigate
              AppleEnableSwipeNavigateWithScrolls = false;
            };

          };

          controlcenter = {
            Display = true;
            Sound = true;
            BatteryShowPercentage = false;
            FocusModes = false;
          };

          screencapture = {
            location = "/Users/shaver/Screenshots"; # save screenshot files here
            target = "clipboard"; # default screenshot to clipboard
            disable-shadow = true; # no shadow border on screenshots
            include-date = true; # date in filenames
            type = "png"; # save screenshots as PNG
          };

          spaces.spans-displays = false; # each display has a different Space

          # only in Stage Manager
          WindowManager.EnableStandardClickToShowDesktop = false;
        };

        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
        };

        #    activationScripts.postActivation.text = ''
        #      echo "WatchID settings"
        #      if ! grep 'pam_watchid.so' > /dev/null; then
        #        ${pkgs.gnused}/bin/sed -i '2i\
        #      auth	sufficient	pam_watchid.so # darwin/default.nix
        #      ' /etc/pam.d/sudo
        #      fi
        #    '';

      };

      services = {
        tailscale.enable = true;
      };

      power = {
        restartAfterFreeze = true;
        restartAfterPowerFailure = true; # not supported on laptop, sigh
      };

      system.primaryUser = lib.mkDefault "shaver";

      networking.wakeOnLan.enable = true;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
    };
}
