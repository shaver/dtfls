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
        inputs.determinate.nixosModules.default
      ]
      ++ (with config.flake.modules.nixos; [
        steam
        desktop-audio
        nix
        desktop
        shaver
      ])
      ++ (with config.flake.commonModules; [
        sudo
      ]);

      # Bootloader.
      boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;

        # Use latest kernel.
        kernelPackages = pkgs.linuxPackages_latest;
      };

      networking = {
        hostName = "splashdown"; # Define your hostname.
        networkmanager.enable = true;
      };

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

      environment.systemPackages = with pkgs; [
        git # for flake management
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

      services.openssh.enable = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?

    };
}
