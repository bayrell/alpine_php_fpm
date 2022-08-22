ARG ARCH=
FROM ${ARCH}/alpine:3.8

RUN cd ~; \
	echo "" > /etc/apk/repositories; \
	echo "https://mirror.yandex.ru/mirrors/alpine/v3.8/main" >> /etc/apk/repositories; \
	echo "https://mirror.yandex.ru/mirrors/alpine/v3.8/community" >> /etc/apk/repositories; \
	apk update; \
	apk upgrade; \
	apk add bash nano mc wget net-tools pv zip unzip supervisor procps grep sudo; \
	rm -rf /var/cache/apk/*; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"

RUN cd ~; \
	apk update; \
	apk add php5 php5-fpm php5-json php5-openssl php5-pdo_mysql php5-curl php5-phar php5-bcmath php5-sockets php5-mysqli php5-soap php5-ctype php5-iconv php5-dom curl nginx mysql-client; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 1000 -S www; \
	adduser -D -H -S -G www -u 1000 www; \
	adduser nginx www; \
	chown -R www:www /var/log/nginx; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'
	
RUN cd ~; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php5/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php5/php.ini; \	
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php5/php.ini; \	
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php5/php.ini; \	
	sed -i 's|listen =.*|listen = /var/run/php-fpm.sock|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;listen.owner =.*|listen.owner = www|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;listen.group =.*|listen.group = www|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;listen.mode =.*|listen.mode = 0660|g' /etc/php5/php-fpm.conf; \
	sed -i 's|user = .*|user = www|g' /etc/php5/php-fpm.conf; \
	sed -i 's|group = .*|group = www|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[error_log] = /var/log/nginx/php_error.log' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php5/php-fpm.conf; \	
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php5/php-fpm.conf; \	
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php5/php-fpm.conf; \	
	ln -sf /proc/1/fd/1 /var/log/nginx/access.log; \
	ln -sf /proc/1/fd/2 /var/log/nginx/php_error.log; \
	ln -sf /proc/1/fd/2 /var/log/nginx/error.log; \
	echo 'Ok'
	
ADD files /src/files
RUN cd ~; \
	rm -f /etc/nginx/conf.d/default.conf; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/usr/* /usr/; \
	cp -rf /src/files/var/* /var/; \
	rm -rf /src/files; \
	chmod +x /root/run.sh; \
	echo 'Ok'	

CMD ["/root/run.sh"]