{
  stdenv,
  gnucobol,
  gcc
}: stdenv.mkDerivation {
  name = "status";
  buildInputs = [
    gnucobol.bin
    gcc
  ];

  src = ./.;

  buildPhase = ''
    cobc -x ./main.cbl
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin/status
  '';
}
