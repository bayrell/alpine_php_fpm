# Alpine php-fpm image

Branches:
- [PHP 5.6](https://github.com/bayrell-os/alpine_php_fpm/tree/branch_5.6)
- [PHP 7.2](https://github.com/bayrell-os/alpine_php_fpm/tree/branch_7.2)
- [PHP 7.3](https://github.com/bayrell-os/alpine_php_fpm/tree/branch_7.3)
- [PHP 7.4](https://github.com/bayrell-os/alpine_php_fpm/tree/branch_7.4)
- [PHP 8.0](https://github.com/bayrell-os/alpine_php_fpm/tree/branch_8.0)
- [PHP 8.3](https://github.com/bayrell-os/alpine_php_fpm/tree/branch_8.3)


## Environments

- ANY_PHP=0 - Enable human url
- ANY_PHP=1 - Enable access by direct php file
- CRON_ENABLE=1 - Enable cron
- TZ=UTC
- DOCUMENT_ROOT=/var/www/html - Setup document root folder
- MYSQL_HOST, MYSQL_LOGIN, MYSQL_PASSWORD, MYSQL_DATABASE - MySQL settings
- WWW_UID, WWW_GID - Setup www user and group id
- MAX_UPLOAD_SIZE - Setup max upload size
- MEMORY_LIMIT  - Setup php memory limit
- PHP_TIME_LIMIT - Setup php time limit
- POST_MAX_SIZE - Setup post max size
