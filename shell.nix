{
  pkgs ? import <nixpkgs> {}
}: with pkgs;
mkShell {
  nativeBuildInputs = [
    gcc
    regina
    gnucobol.bin
  ];
  shellHook = "echo working";
}
