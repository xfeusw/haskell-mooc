{
  pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  hpkgs,
  pre-commit-check,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "haskell-mooc";

  nativeBuildInputs = with pkgs; [
    git
    nixd
    statix
    deadnix
    alejandra
  ];

  buildInputs = [
    hpkgs.ghc
    hpkgs.ghcid
    hpkgs.haskell-language-server
    hpkgs.fourmolu
    hpkgs.hlint
    hpkgs.hpack
    hpkgs.cabal-fmt
    hpkgs.postgresql-libpq
    hpkgs.postgresql-libpq-configure

    pkgs.just
    pkgs.alejandra
    pkgs.zlib
    pkgs.treefmt
    pkgs.libpq.dev
    pkgs.zlib.dev
    pkgs.postgresql
    pkgs.libz
    pkgs.libpq.pg_config
    pkgs.pkg-config
    pkgs.xz

    pre-commit-check.enabledPackages
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.postgresql}/lib
    ${pre-commit-check.shellHook}
  '';

  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
}
