ARG ARCH=amd64
FROM docker.io/bayrell/alpine:3.14-${ARCH}

ARG ARCH
ENV ARCH=${ARCH}

RUN cd ~; \
	apk update; \
	apk upgrade; \
	apk add php8 php8-fpm php8-json php8-mbstring php8-openssl php8-session php8-pdo_mysql php8-curl php8-phar php8-bcmath php8-sockets php8-mysqlnd php8-mysqli php8-soap php8-pecl-mongodb php8-ctype php8-dom php8-gd php8-exif php8-fileinfo php8-pecl-imagick php8-zip php8-iconv php8-xml php8-xmlreader php8-simplexml php8-xmlwriter php8-opcache php8-pecl-apcu php8-pecl-mcrypt php8-intl php8-tokenizer curl nginx mysql-client; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 800 -S www; \
	adduser -D -H -S -G www -u 800 -h /data/home www; \
	adduser nginx www; \
	chown -R www:www /var/log/nginx; \
	echo 'Ok'
	
RUN cd ~; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php8/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php8/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php8/php.ini; \
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php8/php.ini; \
	sed -i 's|;error_log =.*|error_log = /var/log/php8/error.log|g' /etc/php8/php.ini; \
	sed -i 's|listen =.*|listen = /var/run/php-fpm.sock|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;listen.owner =.*|listen.owner = www|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;listen.group =.*|listen.group = www|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;listen.mode =.*|listen.mode = 0660|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|user = .*|user = www|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|group = .*|group = www|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[error_log] = /var/log/php8/error.log' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php8/php-fpm.d/www.conf; \
	ln -sf /proc/1/fd/1 /var/log/nginx/access.log; \
	ln -sf /proc/1/fd/2 /var/log/nginx/error.log; \
	ln -sf /proc/1/fd/2 /var/log/php8/error.log; \
	ln -s /usr/bin/php8 /usr/bin/php; \
	echo 'Ok'
	
ADD files /src/files
RUN cd ~; \
	rm -f /etc/nginx/conf.d/default.conf; \
	rm -f /etc/nginx/fastcgi.conf; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/usr/* /usr/; \
	cp -rf /src/files/var/* /var/; \
	rm -rf /src/files; \
	chmod +x /root/run.sh; \
	echo 'Ok'