#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

void wire_hello(int64_t port_, struct wire_uint_8_list *name);

struct wire_uint_8_list *new_uint_8_list_1(int32_t len);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_hello);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_1);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}