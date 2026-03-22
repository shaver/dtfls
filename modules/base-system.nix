{ inputs, lib, ... }:
{
  flake.modules.generic.base-system =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules; [
        generic.sudo
        generic.nix
      ];
      services.tailscale.enable = true;

      programs.zsh.enable = true;
      time.timeZone = lib.mkDefault "America/Toronto";

      services.openssh.enable = lib.mkDefault true;

      environment.systemPackages = with pkgs; [
        lsof
        file
        git # for flake management
      ];

      # have to force this config globally, see
      # https://stackoverflow.com/questions/79371917/direnv-printing-environment-diff-even-with-hide-env-diff-true/79543570#79543570
      environment.etc."direnv/direnv.toml".text = ''
        [global]
        hide_env_diff = true
      '';
    };

  flake.modules.nixos.base-system =
    {
      pkgs,
      config,
      ...
    }:
    let
      shaver-nixpkgs = import inputs.shaver-nixpkgs {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    in
    {
      imports = [
        inputs.self.modules.generic.base-system
        #       inputs.determinate.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.self.modules.nixos.base-networking
      ];

      environment.systemPackages = with pkgs; [
        pciutils
        usbutils
      ];

      # drkonqi just crash-loops, so...
      systemd.coredump.enable = false;

      # Bootloader.
      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            memtest86.enable = true;
          };
          efi.canTouchEfiVariables = true;
        };

        kernelPackages = lib.mkDefault shaver-nixpkgs.linuxPackages_6_19;
      };

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_CA.UTF-8";
        LC_IDENTIFICATION = "en_CA.UTF-8";
        LC_MEASUREMENT = "en_CA.UTF-8";
        LC_MONETARY = "en_CA.UTF-8";
        LC_NAME = "en_CA.UTF-8";
        LC_NUMERIC = "en_CA.UTF-8";
        LC_PAPER = "en_CA.UTF-8";
        LC_TELEPHONE = "en_CA.UTF-8";
        LC_TIME = "en_CA.UTF-8";
      };

      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    };

  flake.modules.darwin.base-system =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.modules.generic.base-system
        inputs.determinate.darwinModules.default
        inputs.sops-nix.darwinModules.sops
      ];

      users.users.shaver = {
        name = "shaver";
        home = "/Users/shaver";
      };

      security.pam.services.sudo_local.touchIdAuth = true; # Use TouchID for `sudo` authentication

      # These users can add Nix caches.
      nix.settings.trusted-users = [
        "root"
        "shaver"
      ];
      ids.gids.nixbld = 350;

      environment = {
        shells = [ pkgs.zsh ];
        systemPackages = with pkgs; [
          pam-watchid
          coreutils # for GNU ls mostly
          darwin.lsusb
        ];
      };

      fonts.packages = with pkgs; [
        nerd-fonts.meslo-lg
        nerd-fonts.jetbrains-mono
        font-awesome
      ];

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

      power = {
        restartAfterFreeze = true;
        # restartAfterPowerFailure = true; # not supported on laptop, sigh
      };

      system.primaryUser = lib.mkDefault "shaver";

      networking.wakeOnLan.enable = true;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
    };
}
