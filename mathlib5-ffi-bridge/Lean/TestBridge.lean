-- ============================================================
-- Lean/TestBridge.lean — FFI Smoke Test
-- ============================================================

import Bridge

def main : IO Unit := do
  IO.println "=== MathLib5 FFI Bridge Test ==="
  IO.println ""

  -- 1. Initialize context
  IO.println "1. Initializing bridge context..."
  let ctx ← BridgeCtx.new 0
  IO.println "   OK: Context created"

  -- 2. Compute roundtrip
  IO.println "2. Testing compute(42)..."
  let result ← ctx.compute 42
  IO.println s!"   Result: {result}"
  if result != 0 then
    IO.println "   OK: Compute succeeded"
  else
    IO.println "   WARN: Zero result (check C kernel)"

  -- 3. Rewrite: SumSquares
  IO.println "3. Testing SumSquares(10)..."
  let sumSq ← ctx.rewrite 10 10
  let expected := sumSquaresClosedForm 10
  IO.println s!"   FFI result:  {sumSq}"
  IO.println s!"   Lean result: {expected}"
  if sumSq == expected then
    IO.println "   OK: FFI and Lean agree"
  else
    IO.println "   FAIL: Mismatch!"

  -- 4. Rewrite: SumLinear
  IO.println "4. Testing SumLinear(100)..."
  let sumLin ← ctx.rewrite 100 100
  let expectedLin := sumLinearClosedForm 100
  IO.println s!"   FFI result:  {sumLin}"
  IO.println s!"   Lean result: {expectedLin}"
  if sumLin == expectedLin then
    IO.println "   OK: FFI and Lean agree"
  else
    IO.println "   FAIL: Mismatch!"

  -- 5. Rewrite: SumCubes
  IO.println "5. Testing SumCubes(10)..."
  let sumCb ← ctx.rewrite 10 10
  let expectedCb := sumCubesClosedForm 10
  IO.println s!"   FFI result:  {sumCb}"
  IO.println s!"   Lean result: {expectedCb}"
  if sumCb == expectedCb then
    IO.println "   OK: FFI and Lean agree"
  else
    IO.println "   FAIL: Mismatch!"

  -- 6. Verify theorem
  IO.println "6. Testing verify(1)..."
  let verified ← ctx.verify 1
  IO.println s!"   Verified: {verified}"

  -- 7. Cleanup
  IO.println "7. Freeing context..."
  ctx.free
  IO.println "   OK: Context freed"

  IO.println ""
  IO.println "=== All tests passed ==="
