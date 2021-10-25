function nix-haskell() {
	  if [[ $# -lt 2 ]];
	  then
		    echo "Must provide a ghc version (e.g ghc821) and at least one package"
		    return 1;
	  else
		    ghcver=$1
		    pkgs=${@:2}
		    echo "Starting haskell shell, ghc = $ghcver, pkgs = $pkgs"
		    nix-shell -p "haskell.packages.$ghcver.ghcWithPackages (pkgs: with pkgs; [$pkgs])"
	  fi
}
