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
    ./generate_copybooks.sh COPYBOOKS/LIBC.CPY
    rexx BUILD.EXEC
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp statusline $out/bin/status
  '';
}
