{
  flake.modules.homeManager.shaver-secrets = {
    sops = {
      age.keyFile = "/home/shaver/.config/sops/age/keys.txt";
      secrets.ffxiv-otp-secret = {
        sopsFile = ../secrets/users/shaver/secrets.yaml;
      };
      secrets.ha-cli-token = {
        sopsFile = ../secrets/users/shaver/secrets.yaml;
      };
    };
  };
}
