#include <errno.h>
#include <stdlib.h>
#include <string.h>
int DCOB_24GET__ERRNO(void) { return errno; }
int DCOB_24B__OR(int a, int b, int *c) { *c = a | b; return 0; }
int DCOB_24B__AND(int a, int b, int *c) { *c = a & b; return 0; }
int DCOB_24B__XOR(int a, int b, int *c) { *c = a ^ b; return 0; }
int DCOB_24MEMCPY(void *a, void *b, int c) { memcpy(a, b, c); return 0; };
int DCOB_24MEMSET(void *a, char b, int c) { memset(a, b, c); return 0; };
int DCOB_24STRNCPY(void *a, void *b, int c) { strncpy(a, b, c); return 0; };
char* DCOB_24STR__ERROR(void) { return strerror(errno); }
