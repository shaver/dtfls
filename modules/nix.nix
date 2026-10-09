{ inputs, ... }:
{
  flake.modules.generic.nix =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      nix = {
        optimise.automatic = config.nix.enable;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          trusted-users = [
            "shaver"
            "@wheel"
          ];

          # ideally this would be in the noctalia module, but that's a hjem
          # module and can't affect global nix settings
          extra-substituters = [ "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];

          warn-dirty = false;

          # ensure that the registry only contains our inputs
          nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
          flake-registry = "";

          # download-buffer-size = 671088640; # 640MB or 10x the default. lfg
        };
        extraOptions = "!include ${config.sops.secrets.nix-config-github-token.path}";
      };

      programs.tack = {
        enable = true;
        nixConfTokens = true;
      };

      environment.systemPackages = [
        pkgs.rippkgs
      ];
    };

  # per-user nix.conf, so user aspects can bring their own binary caches
  # (only honoured because shaver is a trusted user)
  flake.modules.hjem.nix =
    { config, lib, ... }:
    let
      inherit (lib) types;
      cfg = config.nix.settings;
    in
    {
      options.nix.settings = lib.mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = { };
        description = "Settings written to $XDG_CONFIG_HOME/nix/nix.conf; list values are space-joined.";
      };

      config.xdg.config.files."nix/nix.conf" = lib.mkIf (cfg != { }) {
        text = lib.concatLines (lib.mapAttrsToList (k: v: "${k} = ${toString v}") cfg);
      };
    };
}
