/*
 * CRT mínimo sin TLS para Xfbdev en Eclipse OS.
 * Enlazar con: -nostartfiles crt0_start.o crt0_no_tls.o (nuestros .o primero).
 * _init, _fini, _DYNAMIC están en crt0_start.S.
 */
#include <stddef.h>

extern int main(int argc, char **argv, char **envp);
extern void exit(int);

/* errno is provided by eclipse_libc */

/* Sustituye __libc_setup_tls vía -Wl,--wrap=__libc_setup_tls (evita page fault 0x388).
 * NO definir __libc_setup_tls aquí: solo __wrap___libc_setup_tls para evitar
 * "multiple definition" con libc-tls.o.
 */
void __wrap___libc_setup_tls(void) {
}

/* __crt_start recibe el stack pointer original (SysV ABI) */
void __crt_start(long *sp) {
    long argc = sp[0];
    char **argv = (char **)&sp[1];
    char **envp = (char **)&sp[argc + 2];
    
    /* 
     * Forced Stack Alignment for Xfbdev:
     * Some apps (like Xfbdev) using SIMD/movaps may assume 16-byte alignment at main entry.
     * SysV ABI typically has (16n + 8) at call site. We satisfy the likely expectation 
     * of direct 16-byte alignment by aligning the stack pointer manually.
     */
    void (*main_wrapper)(int, char**, char**) = (void*)main;
    
    __asm__ volatile (
        "mov %1, %%rdi\n\t"    /* argc */
        "mov %2, %%rsi\n\t"    /* argv */
        "mov %3, %%rdx\n\t"    /* envp */
        "and $-16, %%rsp\n\t"  /* Force 16-byte alignment */
        "call *%0\n\t"         /* call main */
        "mov %%eax, %%edi\n\t" /* exit code */
        "call exit\n\t"
        : 
        : "r"(main_wrapper), "r"(argc), "r"(argv), "r"(envp)
        : "rax", "rcx", "rdx", "rsi", "rdi", "r8", "r9", "r10", "r11", "memory"
    );
    
    /* Should not reach here */
    while(1);
}
