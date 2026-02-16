#!/bin/sh
# Configure tinyx for Eclipse OS: minimal OS backend, no Linux /dev/tty or VT.
# Run from eclipse-apps/tinyx/

set -e

# Regenerate configure from configure.ac (so --enable-kdrive-minimal, --with-xfont are recognized)
if ! grep -q 'enable_kdrive_minimal' configure 2>/dev/null || ! grep -q 'with_xfont' configure 2>/dev/null; then
    echo "Regenerating configure..."
    autoreconf -i -f
fi

SYSROOT="${SYSROOT:-/home/moebius/eclipse/eclipse-os-build/sysroot}"

# Enlace estático: Xfbdev sin dependencias .so (necesario para Eclipse OS / spawn desde kernel)
# Al compilar con sysroot (eclipse_libc como libc.a), sysconf, perror, fclose, snprintf, etc. los aporta eclipse_libc.
export LDFLAGS="${LDFLAGS:--Wl,-O1} -static"

# Sin stack canary: evita "mov %fs:0x28,%rax" que falla si TLS no está inicializado (exec desde Eclipse OS)
export CFLAGS="${CFLAGS:--O2} -fno-stack-protector"

# Usar eclipse-apps/libXfont 1.5 (fuentes built-in). Si existe ../libXfont y aún no está en install/, compilar e instalar.
XFONT1_OPT=""
TINYX_INSTALL="$(pwd)/install"
if [ -d "../libXfont" ] && [ ! -f "install/lib/pkgconfig/xfont.pc" ]; then
    echo "Compilando e instalando eclipse-apps/libXfont 1.5 en $TINYX_INSTALL..."
    mkdir -p "$TINYX_INSTALL"
    (cd ../libXfont && ./configure --prefix="$TINYX_INSTALL" --enable-builtins && make -j"$(nproc)" && make install) || true
fi
if [ -n "$TINYX_USE_LIBXFONT1" ] || [ -f "install/lib/pkgconfig/xfont.pc" ]; then
    if [ -f "install/lib/pkgconfig/xfont.pc" ]; then
        export PKG_CONFIG_PATH="${TINYX_INSTALL}/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
    fi
    XFONT1_OPT="--with-xfont=1"
    echo "Using libXfont 1.x (xfont) from $TINYX_INSTALL"
fi

# Sin SSL/TLS (Transport Layer Security): TinyX no incluye OpenSSL ni GnuTLS.
# Desactivamos XDMCP y xdm-auth para no depender de protocolos remotos/seguros.
# Configure natively first to generate correct internal headers and paths.
./configure --prefix=/usr \
    --enable-kdrive \
    --enable-builtin-fonts \
    $XFONT1_OPT \
    --disable-xf86bigfont \
    --disable-dpms \
    --disable-xdmcp \
    --disable-xdm-auth-1 \
    --disable-ipv6 \
    --disable-xvesa

sed -i 's/#define HAVE_ASM_MTRR_H 1/\/* #undef HAVE_ASM_MTRR_H *\//' include/dix-config.h
# Deshabilitar TCP/IP: no usamos red en Eclipse OS (evita getaddrinfo, gethostbyname, etc.)
sed -i 's/^#define TCPCONN .*$/\/\* #undef TCPCONN \*\//' include/dix-config.h
sed -i 's/^#define IPv6 .*$/\/\* #undef IPv6 \*\//' include/dix-config.h
# No sobrescribir dix/fontstub.c (contiene stub débil ResetFontPrivateIndex para el enlace)

echo ""
echo "Configure done. LDFLAGS includes -static for a static Xfbdev binary."
echo "If make fails with 'cannot find -lfontenc' (or similar), install static libs, e.g.:"
echo "  sudo apt install libfontenc-dev (and ensure .a is present)"
echo "To build with sysroot, run:"
echo "  make CC=\"gcc --sysroot=$SYSROOT -fno-stack-protector -fno-PIE -O2\" LDFLAGS=\"-B$SYSROOT/usr/lib -no-pie -static\" LIBS=\"-lz\""
echo "This avoids overriding internal CFLAGS while ensuring sysroot is used for both includes and linking."
