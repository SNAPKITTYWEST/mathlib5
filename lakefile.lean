import Lake
open Lake DSL

-- Mathlib is required for `import Mathlib.*` in the library.
-- Pin to the mathlib tag that matches the toolchain in ./lean-toolchain.
require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "v4.19.0"

@[default_target]
lean_lib Mathlib5 where
  srcDir := "layers/hol/lean"

-- Optional build of the FFI bridge + theorem calculator (needs the C-- kernel):
--   require mathlib5Ffi from "./mathlib5-ffi-bridge"
