{
  perSystem = { pkgs, ... }: {
    make-shells.default = {
      packages = [ pkgs.shake ];
    };
  };
}
