/* Entry point sin glibc: lee argc/argv/envp del stack y llama a __crt_start.
 * El kernel Eclipse pone en el stack: argc, argv[0], envp[0], auxv AT_NULL.
 * ABI x86-64: rdi=argc, rsi=argv, rdx=envp.
 */
    .section .note.GNU-stack,"",@progbits
    .text
    .globl _start
    .type _start, @function
_start:
    mov 0(%rsp), %rdi          /* argc */
    lea 8(%rsp), %rsi          /* argv */
    lea 8(%rsp), %rax
    mov (%rsp), %rcx
    add $1, %rcx
    shl $3, %rcx
    add %rcx, %rax
    mov %rax, %rdx             /* envp = argv + (argc+1)*8 */
    and $-16, %rsp             /* ABI: stack 16-byte aligned before call */
    call __crt_start
    mov %eax, %edi
    call exit
    hlt
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
