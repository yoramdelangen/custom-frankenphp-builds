param(
    [string]$PhpVersion = "8.4",
    [string]$Extensions = "odbc,pdo_odbc,bcmath,calendar,ctype,curl,dba,dom,exif,fileinfo,filter,gd,libxml,mbregex,mbstring,ldap,msgpack,mysqli,mysqlnd,opcache,openssl,pcntl,pdo,pdo_mysql,pdo_pgsql,pdo_sqlite,pdo_sqlsrv,pgsql,phar,posix,readline,redis,session,simplexml,sockets,sodium,sqlite3,sqlsrv,tokenizer,xml,xmlreader,xmlwriter,zip,zlib"
)

$ErrorActionPreference = "Stop"

throw @"
FrankenPHP's Windows build does not use static-php-cli and cannot build the requested
custom extension set into the binary.

PHP version: $PhpVersion
Requested extensions: $Extensions

Use build-linux-gnu.sh or build-macos-arm64.sh for custom static extensions. Windows
support requires a FrankenPHP Windows toolchain change first.
"@
