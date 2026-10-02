// stdatomic.h
// TubeFixLegacy - C11 atomics for compilers that don't ship <stdatomic.h>
// (Apple LLVM 4.2 in Xcode 4.6.3). xcode/build.sh only puts this directory
// on the include path when the compiler can't find its own stdatomic.h.
//
// Covers exactly what the vendored protobuf runtime uses: _Atomic(pointer),
// atomic_load and atomic_compare_exchange_strong on pointers.

#ifndef TFL_STDATOMIC_SHIM_H
#define TFL_STDATOMIC_SHIM_H

#define _Atomic(T) T volatile

static __inline__ __attribute__((always_inline)) void *tfl_atomic_load_ptr(void * volatile *object) {
    __sync_synchronize();
    void *value = *object;
    __sync_synchronize();
    return value;
}

static __inline__ __attribute__((always_inline)) int tfl_atomic_cas_ptr(void * volatile *object, void **expected, void *desired) {
    void *old = __sync_val_compare_and_swap(object, *expected, desired);
    if (old == *expected) {
        return 1;
    }
    *expected = old;
    return 0;
}

#define atomic_load(object) ((__typeof__(*(object)))tfl_atomic_load_ptr((void * volatile *)(object)))
#define atomic_compare_exchange_strong(object, expected, desired) \
    tfl_atomic_cas_ptr((void * volatile *)(object), (void **)(expected), (void *)(desired))

#endif
