{
  # decrypted by the system sops-nix module (imported in base-system) and
  # handed to shaver, rather than by a per-user activation
  flake.modules.generic.shaver-secrets =
    { config, ... }:
    let
      secret = {
        sopsFile = ../secrets/users/shaver/secrets.yaml;
        owner = "shaver";
      };
    in
    {
      sops = {
        age.keyFile = "${config.users.users.shaver.home}/.config/sops/age/keys.txt";
        secrets = {
          ffxiv-otp-secret = secret;
          ha-cli-token = secret;
          nix-config-github-token = secret;
        };
      };

      nix.extraOptions = "!include ${config.sops.secrets.nix-config-github-token.path}";
    };
}
