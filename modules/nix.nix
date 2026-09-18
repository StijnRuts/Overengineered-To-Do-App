{
  perSystem = { pkgs, ... }: {
    make-shells.default =
      let
        lsp = pkgs.nixd;
      in
      {
        packages = [ lsp ];
      };

    treefmt = {
      programs = {
        nixfmt.enable = true;
        nixfmt.strict = true;
        statix.enable = true;
        deadnix.enable = true;
      };
    };
  };
}
