-- ============================================================
-- Lean/Build.lean — Build hooks and module exports
-- ============================================================

-- Re-export all FFI bindings and wrappers
import Lean.Bridge

-- Module-level documentation
/-- MathLib5 FFI Bridge: Lean 4 ↔ C-- verified compute kernel.

    This module provides:
    - Opaque `BridgeCtx` handle for FFI context management
    - `bridgeInit` / `bridgeFree` / `bridgeCompute` FFI primitives
    - High-level `BridgeCtx.new` / `.compute` / `.rewrite` / `.verify` API
    - Lean-side closed-form implementations for cross-validation

    Usage:
    ```
    let ctx ← BridgeCtx.new 0
    let result ← ctx.compute 42
    let sumSq ← ctx.rewrite 10 10  -- SumSquares(10)
    ctx.free
    ```
-/

-- Export everything from Bridge.lean
-- (already imported above)
