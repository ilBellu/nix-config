{
  callPackage,
  cargo-watch,
  rust-analyzer,
  rustfmt,
  clippy,
}: let
  mainPkg = callPackage ./default.nix {};
in
  mainPkg.overrideAttrs (oa: {
    nativeBuildInputs =
      [
        # Additional rust tooling
        cargo-watch
        rust-analyzer
        rustfmt
        clippy
      ]
      ++ (oa.nativeBuildInputs or []);
  })
