{ inputs, ... }:
{
  flake.modules.darwin.shaver-work = {
    imports = with inputs.self.modules.darwin; [
      shaver-base
      aerospace
      homebrew
    ];

    home-manager.users.shaver = {
      imports = with inputs.self.modules.homeManager; [ shaver-work-darwin ];
    };
  };
  flake.modules.homeManager.shaver-work-darwin =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [ shaver-work ];
    };

  flake.modules.homeManager.shaver-work =
    { pkgs, ... }:
    let
      gcloud-with-auth = pkgs.google-cloud-sdk.withExtraComponents (
        with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]
      );
    in
    {
      imports = with inputs.self.modules.homeManager; [ shaver-base ];
      home.packages = with pkgs; [
        fastly
        awscli2
        gcloud-with-auth
        gnupg

        go-junit-report
        golangci-lint

        rclone
        s3cmd
      ];
    };
}
