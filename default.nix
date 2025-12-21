{
  stdenv,
  gnucobol,
  regina,
  gcc
}: stdenv.mkDerivation {
  name = "status";
  buildInputs = [
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
