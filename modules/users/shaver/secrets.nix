{
  flake.modules.homeManager.shaver-secrets = { config, ... }: {
    sops = {
      age.keyFile = "/home/shaver/.config/sops/age/keys.txt";
      secrets.ffxiv-otp-secret = {
        sopsFile = ../../../secrets/users/shaver/secrets.yaml;
        # owner = "shaver";
        # group = config.users.users.shaver.group;
      };
    };
  };
}
