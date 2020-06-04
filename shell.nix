with import <nixpkgs> { };
mkShell {
  name = "env";
  buildInputs = [ terraform azure-cli azure-func figlet ];
  shellHook = ''
    figlet ":azure func:"
  '';
}
