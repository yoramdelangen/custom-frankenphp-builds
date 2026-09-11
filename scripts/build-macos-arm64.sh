#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PHP_VERSION="${1:-8.4}"
PHP_EXTENSIONS="${2:-odbc,pdo_odbc,bcmath,calendar,ctype,curl,dba,dom,exif,fileinfo,filter,gd,libxml,mbregex,mbstring,ldap,msgpack,mysqli,mysqlnd,opcache,openssl,pcntl,pdo,pdo_mysql,pdo_pgsql,pdo_sqlite,pdo_sqlsrv,pgsql,phar,posix,readline,redis,session,simplexml,sockets,sodium,sqlite3,sqlsrv,tokenizer,xml,xmlreader,xmlwriter,zip,zlib}"

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
	printf 'This script must run on an Apple Silicon macOS host\n' >&2
	exit 1
fi

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
export AR=/usr/bin/ar
export LD=/usr/bin/ld
export NM=/usr/bin/nm
export RANLIB=/usr/bin/ranlib
export STRIP=/usr/bin/strip

# Do not let Homebrew's PHP and library paths win over static-php-cli's buildroot.
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LIBS LIBRARY_PATH CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH

# Keep the required FrankenPHP libraries; static-php-cli's macOS HTTP/3 build is incomplete.
export PHP_EXTENSION_LIBS="${PHP_EXTENSION_LIBS:-watcher,brotli}"

cd "${ROOT_DIR}/frankenphp"
PHP_VERSION="${PHP_VERSION}" PHP_EXTENSIONS="${PHP_EXTENSIONS}" PHP_EXTENSION_LIBS="${PHP_EXTENSION_LIBS}" CI=1 ./build-static.sh
"${ROOT_DIR}/frankenphp/dist/frankenphp-mac-arm64" list-modules
