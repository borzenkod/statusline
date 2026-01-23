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
    rexx ./TESTS/TEST.EXEC
    rexx BUILD.EXEC
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin/status
  '';
}
