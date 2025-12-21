{
  pkgs,
  stdenv,
}: stdenv.mkDerivation {
  name = "status";
  buildInputs = with pkgs; [
    gnucobol.bin
    regina
    gcc
  ];

  src = ./.;

  buildPhase = ''
    regina build.rexx
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin/status
  '';
}
