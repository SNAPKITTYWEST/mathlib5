# MATHLIB5

> **A verified symbolic-compute pipeline — from APL surface syntax to proof-carrying machine code.**
>
> `Ω ← TRUST ∧ CODE`

Part of the **SNAPKITTYWEST** sovereign-compute constellation. Extracted from the `all-apl`
workspace and sealed into the Bifrost WORM chain under provenance
`Bifrost_WORM_Chain_20260710_01`.

---

## OVERVIEW

MATHLIB5 is a multi-language **Verified Symbolic Compute Pipeline (VSCP)**. It takes a
mathematical expression written in APL, lowers it through a canonical S-expression
intermediate representation, refines and proves it (Liquid Haskell → Lean 4), executes it on
a hand-written verified C-- kernel, cross-validates the result with logic engines
(FOL/CodeQL, ASP/Prolog), and seals the whole transaction with proof certificates in a
tamper-evident WORM ledger.

The organizing idea is **proof-carrying transformation**: every rewrite, normalization, or
closed-form substitution emits a certificate (a SHA-256 of the rule plus a structural Merkle
root), so results are not merely computed — they are *witnessed*.

## WHAT IT IS

- A **Cargo workspace** (`Cargo.toml`) of Rust layers: `axiom-proof`, `prism-skills`,
  `pnp-attack`, `collatz`, `math-skills`, `sorryhunter`, `rexx-interp`.
- A **Lean 4 FFI bridge** (`mathlib5-ffi-bridge/`) binding Lean to the C-- kernel via
  `@[extern]` declarations, plus closed-form theorem calculators.
- A **verified C-- kernel** (`kernel/verified_kernel.cm`) — portable assembly implementing
  polynomial arithmetic, matrix multiply, symbolic differentiation, structural equality, and
  certificate-emitting rewrite/normalize primitives.
- A **hermetic build environment**: a Nix flake (`flake.nix`) and a Bazel workspace
  (`WORKSPACE.bazel`) pinning Lean 4, Dyalog APL, LLVM 18, Z3, cvc5, GHC 9.8.2 with Liquid
  Haskell, and Bazel.
- **Verified theorems** (`theorems/THEOREMS.md`): SumLinear, SumSquares, SumCubes, each with a
  closed form realized in Lean (`Lean/Bridge.lean`).

## ARCHITECTURE / COMPONENTS

The pipeline is conceived as a 10-layer stack; the layers present in this repo are documented
under `layers/` and the kernel/bridge dirs:

| Path | Language | Purpose |
|------|----------|---------|
| `kernel/verified_kernel.cm` | C-- | Verified arithmetic, matrix, differentiation, rewrite/normalize with certificates |
| `mathlib5-ffi-bridge/Lean/Bridge.lean` | Lean 4 | FFI bindings to the C-- kernel + closed-form rewrite API |
| `mathlib5-ffi-bridge/lakefile.lean` | Lean 4 | Lake targets: `bridge_exec`, `theorem_calc`, foreign lib |
| `mathlib5-ffi-bridge/scripts/verify.sh` | Bash | Standalone verification gate → sealed receipt |
| `layers/fol/` | C99/Datalog | FOL resolution checker (15/15 theorems verified) |
| `layers/asp/` | Clingo | Answer Set Programming, non-monotonic reasoning |
| `layers/codeql/` | Datalog | CodeQL meta-validation of the pipeline |
| `layers/prism-skills/` | Rust | Canonical JSON, SHA-256d, WORM sealing |
| `layers/pnp-attack/` | Rust | Multi-agent P/NP proof search with WORM ledger |
| `layers/sorryhunter/` | Rust | Symbolic kernel + tactics + FFI to close Lean 4 `sorry`s |
| `examples/playground/simple_sum.apl` | APL | `SumSquares ← {+/(⍳⍵)*2}` demo input |
| `ci/run_e2e.sh` | Bash | End-to-end pipeline scaffold: APL → S-expr → Lean → LLVM → linked exe |
| `docs/generate-docs.mjs` | Node | Documentation generator (`--watch` supported) |
| `metadata.json` | JSON | WORM provenance, Plasma Gate seal, split manifest |

### Kernel primitives (`verified_kernel.cm`)

| Export | Function |
|--------|----------|
| `arena_init` | Arena allocator bootstrap |
| `poly_add_verified` | Coefficient-vector polynomial addition |
| `mat_mul_verified` | Dimension-checked matrix multiplication |
| `differentiate` | Symbolic differentiation over tagged expr nodes |
| `is_equal_verified` | Structural / decision-procedure equality (PRISM-style) |
| `rewrite_with_cert` | Rule rewriting with WORM-validated certificate |
| `normalize_with_cert` | Canonicalization emitting a receipt seal |

### Closed-form theorems (`Lean/Bridge.lean`)

```
SumLinear : Σ_{k=1}^n k       = n(n+1)/2
SumSquares: Σ_{k=1}^n k²      = n(n+1)(2n+1)/6
SumCubes  : Σ_{k=1}^n k³      = (n(n+1)/2)²
```

## HOW IT FITS THE CONSTELLATION

- **WORM chain / Bifrost** — `metadata.json` anchors this repo to
  `Bifrost_WORM_Chain_20260710_01`; status `awaiting_worm_seal`, split across audit, kernel,
  proofs, runtime, witnesses, refinements, asp_gate, fol_engine, prism_skills.
- **Plasma Gate / Ed25519** — metadata declares `plasma_gate: Ed25519_Enforced`, integrity via
  SHA-256 append-only chain, payloads under AES-256-GCM.
- **P/NP swarm** — `layers/pnp-attack/` is the local solver node: agents find witnesses
  (NP-hard), the kernel/verifiers check certificates in P-time.
- **3-witness verification** — `scripts/verify.sh` runs the compile/build/FFI/theorem/receipt
  gate and seals a `manifest.json` + `seal.sha256`; results are `VERIFIED` only when all checks
  pass. This mirrors the constellation's multi-witness convergence discipline.

## BUILD / USAGE / INSTALL

Enter the hermetic dev shell (all toolchains pinned):

```bash
nix develop            # Lean 4, Dyalog APL, LLVM 18, Z3, cvc5, GHC + Liquid Haskell, Bazel
```

Build the Rust workspace:

```bash
cargo build --workspace
```

Build & verify the Lean ↔ C-- bridge:

```bash
cd mathlib5-ffi-bridge
lake build                      # builds bridge_exec + theorem_calc
./scripts/verify.sh             # 5-stage verification gate → sealed receipt
```

Run the end-to-end pipeline scaffold on an APL source:

```bash
./ci/run_e2e.sh examples/playground/simple_sum.apl
```

Generate docs:

```bash
node docs/generate-docs.mjs        # add --watch for continuous mode
```

## KEY FILES REFERENCE

| File | Why it matters |
|------|----------------|
| `Cargo.toml` | Workspace root enumerating the Rust proof/skill layers |
| `flake.nix` | Reproducible toolchain (Lean/APL/LLVM/Z3/cvc5/GHC/Bazel) |
| `WORKSPACE.bazel` | Bazel rules for Haskell, Lean 4, LLVM/MLIR |
| `kernel/verified_kernel.cm` | The trusted computing base — verified C-- primitives |
| `mathlib5-ffi-bridge/Lean/Bridge.lean` | Lean-side FFI + closed-form theorem API |
| `mathlib5-ffi-bridge/scripts/verify.sh` | Receipt-sealing verification gate |
| `theorems/THEOREMS.md` | Canonical list of verified summation identities |
| `metadata.json` | WORM/Bifrost provenance and Plasma Gate seal |

## LICENSE

Apache-2.0. Created by Ahmad Ali Parr · SnapKitty Collective · the-49th-call · SNAPKITTYWEST · 2026.
