with import <nixpkgs> {};
mkShell {
    name = "spotify-backup-dev";
    buildInputs = [ crystal openssl pkg-config python3 inkscape ];   
}
