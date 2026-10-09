{
  flake.modules.hjem.irssi =
    { pkgs, ... }:
    {
      packages = [ pkgs.irssi ];

      files.".irssi/config".text = ''
        settings = {
          core = {
            settings_autosave = "no";
          };
        };

        chatnets = {
          sizone = {
            type = "IRC";
            nick = "shaver";
          };
        };

        # just for old time's sake
        servers = (
          {
            chatnet = "sizone";
            address = "irc.sizone.org";
            port = "6667";
            use_ssl = "yes";
            ssl_verify = "yes";
            autoconnect = "yes";
          }
        );

        channels = (
          {
            chatnet = "sizone";
            name = "#tek";
            autojoin = "yes";
          }
        );
      '';
    };
}
