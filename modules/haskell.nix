{ lib, ... }: {
  perSystem = { pkgs, ... }: {
    make-shells.default =
      let
        version = "9.10.3";

        tools = [
          (pkgs.haskell.packages."ghc${lib.replaceString "." "" version}".ghcWithPackages (p: [
            p.shake
            p.zlib
          ]))
          pkgs.cabal-install
          pkgs.ghcid
        ];

        lsp = pkgs.haskell-language-server;
      in
      {
        packages = tools ++ [ lsp ];
      };

    treefmt = {
      programs = {
        ormolu.enable = true;
        hlint.enable = true;
        cabal-gild.enable = true;
      };
    };
  };
}
