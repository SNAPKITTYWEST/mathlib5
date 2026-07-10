-- ============================================================
-- Lakefile — MATHLIB5 FFI Bridge + Theorem Calculator
-- ============================================================

@[default_target]
target mathlib5_ffi_bridge

@[executable]
target bridge_exec
  @[cc] "C/src/bridge.c"
  @[ld] "-lbridge"

@[executable]
target theorem_calc
  roots := #[`Lean.TheoremCalc.Main]
  @[cc] "C/src/bridge.c"
  @[ld] "-lbridge"

@[foreign_library]
foreign_library bridge_lib
  @[header] "C/include/bridge.h"
  @[output] "Lean/Bridge.lean"
