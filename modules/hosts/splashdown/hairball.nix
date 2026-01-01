{
  config,
  inputs,
  ...
}:
{
  flake.modules.nixos.splashdown =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.shaver = import ../../../home.nix;
          };
        }
        inputs.determinate.nixosModules.default
      ]
      ++ (with config.flake.modules.nixos; [
        steam
        desktop-audio
      ]);

      # Bootloader.
      boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;

        # Use latest kernel.
        kernelPackages = pkgs.linuxPackages_latest;
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      networking.hostName = "splashdown"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      programs.zsh.enable = true;
      # Set your time zone.
      time.timeZone = "America/Toronto";

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

      # Enable the X11 windowing system.
      # You can disable this if you're only using the Wayland session.
      services.xserver.enable = true;

      # Enable the KDE Plasma Desktop Environment.
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Enable CUPS to print documents.
      # services.printing.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.shaver = {
        isNormalUser = true;
        description = "Mike Shaver";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = with pkgs; [
          discord
          #  kdePackages.kate
          #  thunderbird
        ];
        shell = pkgs.zsh;
      };

      # Install firefox.
      programs.firefox.enable = true;

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        git # for flake management
        #  wget
      ];

      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };

      powerManagement.enable = true;
      systemd.sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
        AllowHybridSleep=no
        AllowSuspendThenHibernate=no
      '';

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

      programs.niri.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?

    };
}
