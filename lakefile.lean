import Lake
open Lake DSL

package Mathlib5 where
  -- Sources live under layers/hol/lean (the Mathlib5.GatesNormalization module).
  srcDir := "layers/hol/lean"

-- Mathlib is required for `import Mathlib.*` in the library.
-- Pin to the mathlib tag that matches the toolchain in ./lean-toolchain.
require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "v4.19.0"

@[default_target]
lean_lib Mathlib5
