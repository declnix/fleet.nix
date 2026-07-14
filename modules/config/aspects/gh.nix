{
  den.aspects.gh = {
    hjem = { pkgs, ... }: {
      packages = [ pkgs.gh ];

      rum.programs.git.settings.credential = {
        "https://github.com".helper = [
          ""
          "!${pkgs.gh}/bin/gh auth git-credential"
        ];
        "https://gist.github.com".helper = [
          ""
          "!${pkgs.gh}/bin/gh auth git-credential"
        ];
      };
    };
  };
}
