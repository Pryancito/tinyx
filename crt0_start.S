/* Entry point sin glibc: lee argc/argv/envp del stack y llama a __crt_start.
 * El kernel Eclipse pone en el stack: argc, argv[0], envp[0], auxv AT_NULL.
 * ABI x86-64: rdi=argc, rsi=argv, rdx=envp.
 */
    .section .note.GNU-stack,"",@progbits
    .text
    .globl _start
    .type _start, @function
_start:
    xor %rbp, %rbp            /* Clear RBP per SysV ABI (terminates backtrace) */
    mov %rsp, %rdi            /* Pass current stack pointer as first argument (RDI) */
    
    /* ABI requirement: stack MUST be 16-byte aligned before calling a function. */
    and $-16, %rsp
    sub $8, %rsp              /* Subtract 8 to account for the call push, keeping it 16-byte aligned *after* call */
    
    call __crt_start
    
    /* If __crt_start returns, exit with its return value */
    mov %eax, %edi
    call exit
    hlt                       /* Should never reach here */
    .size _start, . - _start

/* Stubs globales para glibc estático (crt1/crti) */
    .globl _init
    .type _init, @function
_init:
    ret
    .size _init, . - _init

    .globl _fini
    .type _fini, @function
_fini:
    ret
    .size _fini, . - _fini

/* Stub para _dl_relocate_static_pie (enlace estático) */
    .data
    .globl _DYNAMIC
    .type _DYNAMIC, @object
    .size _DYNAMIC, 1
_DYNAMIC:
    .byte 0
