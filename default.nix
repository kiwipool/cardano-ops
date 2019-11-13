{ sourcePaths ? import ./nix/sources.nix
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
}@args: with import ./nix args; {
  shell = let
    cardanoSL = import sourcePaths.cardano-sl {};
  in  mkShell {
    buildInputs = [ niv nixops nix cardano-cli telnet dnsutils ] ++
                  (with cardanoSL.nix-tools.exes; [ cardano-sl-auxx cardano-sl-tools ]);
    NIX_PATH = "nixpkgs=${path}";
    NIXOPS_DEPLOYMENT = "${globals.deploymentName}";
    passthru = {
      gen-graylog-creds = iohk-ops-lib.scripts.gen-graylog-creds { staticPath = ./static; };
    };
  };
}
