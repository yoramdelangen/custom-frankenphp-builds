#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PHP_VERSION="${1:-8.4}"
PHP_EXTENSIONS="${2:-odbc,pdo_odbc,bcmath,calendar,ctype,curl,dba,dom,exif,fileinfo,filter,gd,libxml,mbregex,mbstring,ldap,msgpack,mysqli,mysqlnd,opcache,openssl,pcntl,pdo,pdo_mysql,pdo_pgsql,pdo_sqlite,pdo_sqlsrv,pgsql,phar,posix,readline,redis,session,simplexml,sockets,sodium,sqlite3,sqlsrv,tokenizer,xml,xmlreader,xmlwriter,zip,zlib}"

command -v docker >/dev/null || {
	printf 'docker is required\n' >&2
	exit 1
}

export GITHUB_TOKEN="${GITHUB_TOKEN:-}"

cd "${ROOT_DIR}/frankenphp"
docker buildx build \
	--file static-builder-gnu.Dockerfile \
	--build-arg FRANKENPHP_VERSION=local \
	--build-arg PHP_VERSION="${PHP_VERSION}" \
	--build-arg PHP_EXTENSIONS="${PHP_EXTENSIONS}" \
	--build-arg CI=1 \
	--secret id=github-token,env=GITHUB_TOKEN \
	--tag custom-frankenphp-gnu \
	--load .

container="$(docker create custom-frankenphp-gnu)"
trap 'docker rm "${container}" >/dev/null 2>&1 || true' EXIT
mkdir -p "${ROOT_DIR}/dist"
docker cp "${container}:/go/src/app/dist/frankenphp-linux-x86_64" "${ROOT_DIR}/dist/frankenphp-linux-x86_64-gnu"
"${ROOT_DIR}/dist/frankenphp-linux-x86_64-gnu" list-modules
