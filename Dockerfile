ARG ARCH=
FROM ${ARCH}alpine:3.20

RUN cd ~; \
	apk update; \
	apk add bash nano mc wget curl net-tools pv zip unzip supervisor procps grep sudo util-linux tzdata; \
	rm -rf /var/cache/apk/*; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"

RUN cd ~; \
	apk add php83 php83-fpm php83-json php83-mbstring php83-openssl php83-session php83-pdo_mysql php83-curl php83-phar php83-bcmath php83-sockets php83-mysqlnd php83-mysqli php83-soap php83-pecl-mongodb php83-ctype php83-dom php83-gd php83-exif php83-fileinfo php83-pecl-imagick php83-zip php83-iconv php83-xml php83-xmlreader php83-simplexml php83-xmlwriter php83-opcache php83-pecl-apcu php83-pecl-mcrypt php83-intl php83-tokenizer php83-pdo_sqlite cronie nginx mysql-client; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 800 -S www; \
	adduser -D -H -S -G www -u 800 -H www; \
	adduser nginx www; \
	echo 'Ok'

RUN cd ~; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php83/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php83/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php83/php.ini; \
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php83/php.ini; \
	sed -i 's|;error_log =.*|error_log = /dev/stderr|g' /etc/php83/php.ini; \
	sed -i 's|listen =.*|listen = /var/run/php-fpm.sock|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;listen.owner =.*|listen.owner = www|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;listen.group =.*|listen.group = www|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;listen.mode =.*|listen.mode = 0660|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|user = .*|user = www|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|group = .*|group = www|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[error_log] = /dev/stderr' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php83/php-fpm.d/www.conf; \
	ln -sf /dev/stdout /var/log/nginx/access.log; \
	ln -sf /dev/stderr /var/log/nginx/error.log; \
	ln -sf /dev/stderr /var/log/php83/error.log; \
	ln -s /usr/bin/php83 /usr/bin/php; \
	echo 'Ok'

RUN cd ~; \
	addgroup -g 1000 -S user; \
	adduser -D -H -S -G user -u 1000 -h /data/home user; \
	adduser user wheel; \
	echo "Ok"

ADD files /
RUN cd ~; \
	rm -f /etc/nginx/conf.d/default.conf; \
	rm -f /etc/nginx/fastcgi.conf; \
	mkdir -p /data; \
	chmod +x /root/main.py; \
	chmod +x /root/run.sh; \
	chmod +x /root/entrypoint.sh; \
	echo 'Ok'

USER user
ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["/root/run.sh"]