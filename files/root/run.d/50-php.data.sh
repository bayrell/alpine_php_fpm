if [ ! -d /data/php ]; then
	mkdir -p /data/php
	chown www:www /data/php
fi
if [ ! -d /data/php/session ]; then
	mkdir -p /data/php/session
	chown www:www /data/php/session
fi
if [ ! -d /data/php/wsdlcache ]; then
	mkdir -p /data/php/wsdlcache
	chown www:www /data/php/wsdlcache
fi
if [ ! -d /data/home ]; then
	mkdir -p /data/home
	chown -R www:www /data/home
fi
if [ ! -z $TZ ]; then
	sed -i "s|date.timezone = .*|date.timezone = $TZ|g" /etc/php7/php.ini
fi
if [ ! -z $PHP_TIME_LIMIT ]; then
	sed -i "s|php_admin_value\[max_execution_time\] = .*|php_admin_value[max_execution_time] = $PHP_TIME_LIMIT|g" /etc/php7/php-fpm.d/www.conf
	sed -i "s|max_execution_time = .*|max_execution_time = $PHP_TIME_LIMIT|g" /etc/php7/php.ini
	echo "fastcgi_read_timeout $PHP_TIME_LIMIT;" >> /etc/nginx/fastcgi_params
fi
