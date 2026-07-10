#!/usr/bin/env bash
# ============================================================
# verify.sh — Standalone Verification Gate
# Usage: ./scripts/verify.sh
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRIDGE_DIR="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${CYAN}[VERIFY]${NC} $*"; }
ok()  { echo -e "${GREEN}[PASS]${NC} $*"; }
fail(){ echo -e "${RED}[FAIL]${NC} $*"; }

cd "$BRIDGE_DIR"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  MATHLIB5 Verification Gate                     ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

PASS=0
FAIL=0

# Test 1: C bridge compiles
log "Test 1: C bridge compilation"
if clang -shared -fPIC -o libbridge.so C/src/bridge.c -I C/include 2>/dev/null; then
  ok "C bridge compiles"
  PASS=$((PASS + 1))
else
  fail "C bridge compilation failed"
  FAIL=$((FAIL + 1))
fi

# Test 2: Lean build
log "Test 2: Lean build"
if lake build 2>/dev/null; then
  ok "Lean build succeeded"
  PASS=$((PASS + 1))
else
  fail "Lean build failed"
  FAIL=$((FAIL + 1))
fi

# Test 3: FFI roundtrip
log "Test 3: FFI roundtrip test"
OUTPUT=$(lean --run Lean/TestBridge.lean 2>&1)
if echo "$OUTPUT" | grep -q "All tests passed"; then
  ok "FFI roundtrip verified"
  PASS=$((PASS + 1))
else
  fail "FFI roundtrip failed"
  echo "$OUTPUT" | tail -5
  FAIL=$((FAIL + 1))
fi

# Test 4: Theorem calculator
log "Test 4: Theorem calculator"
if lake build theorem_calc 2>/dev/null; then
  ok "Theorem calculator built"
  PASS=$((PASS + 1))
else
  fail "Theorem calculator build failed"
  FAIL=$((FAIL + 1))
fi

# Test 5: Receipt generation
log "Test 5: Receipt generation"
mkdir -p build/receipt
cat > build/receipt/manifest.json << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "tests_passed": $PASS,
  "tests_failed": $FAIL,
  "status": "$([ $FAIL -eq 0 ] && echo 'VERIFIED' || echo 'FAILED')"
}
EOF
sha256sum build/receipt/manifest.json | cut -d' ' -f1 > build/receipt/seal.sha256
ok "Receipt sealed"
PASS=$((PASS + 1))

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  Results: $PASS passed, $FAIL failed"
if [ $FAIL -eq 0 ]; then
echo "║  Status: ✅ VERIFIED"
else
echo "║  Status: ❌ FAILED"
fi
echo "╚══════════════════════════════════════════════════╝"
echo ""

exit $FAIL
