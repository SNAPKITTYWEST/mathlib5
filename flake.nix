{ description = "MATHLIB5 — Verified Symbolic Compute Stack";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    haskell-nix.url = "github:input-output-hk/haskell.nix";
    lean4.url = "github:leanprover/lean4";
    apl.url = "github:Dyalog/dyalog";
    llvm.url = "github:llvm/llvm-project/release/18.x";
    z3.url = "github:Z3Prover/z3";
    cvc5.url = "github:cvc5/cvc5";
    bazel.url = "github:bazelbuild/bazel";
  };
  outputs = { self, nixpkgs, haskell-nix, lean4, apl, llvm, z3, cvc5, bazel, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; overlays = [ haskell-nix.overlay ]; };
      ghc = pkgs.haskell.compiler.ghc982;
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          ghc
          (haskell-nix.haskellPackages.ghcWithPackages (p: with p; [
            liquidhaskell
            tasty tasty-quickcheck tasty-hunit
            singletons
            dependent-map
            aeson
            text
            vector
          ]))
          lean4.packages.${system}.lean
          apl
          llvm.packages.${system}.llvm
          z3
          cvc5
          bazel
          python311Packages.pytest
          python311Packages.hypothesis
        ];
      };
    };
}
