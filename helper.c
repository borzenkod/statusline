#include <errno.h>
int DCOB_24GET__ERRNO(void) { return errno; }
int DCOB_24B__OR(int a, int b, int *c) { *c = a | b; return 0; }
int DCOB_24B__AND(int a, int b, int *c) { *c = a & b; return 0; }
int DCOB_24B__XOR(int a, int b, int *c) { *c = a ^ b; return 0; }
