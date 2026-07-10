#ifndef BRIDGE_H
#define BRIDGE_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

// Opaque handle — no Rust/Lean memory model leakage
typedef struct BridgeContext BridgeContext;

// Constructor / Destructor
BridgeContext* bridge_init(uint64_t config_flags);
void bridge_free(BridgeContext* ctx);

// Pure compute kernel (C-- style: no allocations, no syscalls)
int64_t bridge_compute(BridgeContext* ctx, int64_t input);

// Extended: symbolic rewrite engine
int64_t bridge_rewrite(BridgeContext* ctx, int64_t pattern_id, int64_t input);

// Extended: verification status
int32_t bridge_verify(BridgeContext* ctx, int64_t theorem_id);

#ifdef __cplusplus
}
#endif
#endif
