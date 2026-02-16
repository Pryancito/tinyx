/*
 * CRT mínimo sin TLS para Xfbdev en Eclipse OS.
 * Enlazar con: -nostartfiles crt0_start.o crt0_no_tls.o (nuestros .o primero).
 * _init, _fini, _DYNAMIC están en crt0_start.S.
 */
#include <stddef.h>

extern int main(int argc, char **argv, char **envp);
extern void exit(int);

static int errno_storage;

int *__errno_location(void) {
    return &errno_storage;
}

/* Sustituye __libc_setup_tls vía -Wl,--wrap=__libc_setup_tls (evita page fault 0x388).
 * NO definir __libc_setup_tls aquí: solo __wrap___libc_setup_tls para evitar
 * "multiple definition" con libc-tls.o.
 */
void __wrap___libc_setup_tls(void) {
}

void __crt_start(long argc, char **argv, char **envp) {
    int ret = main((int)argc, argv, envp);
    exit(ret);
}
