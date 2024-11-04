if [ ! -z $WWW_UID ] && [ ! -z $WWW_GID ]; then
	sed -i "s|user = .*|user = $WWW_UID|g" /etc/php83/php-fpm.d/www.conf
	sed -i "s|group = .*|group = $WWW_GID|g" /etc/php83/php-fpm.d/www.conf
	chown -R $WWW_UID:$WWW_GID /var/log/php83
fi
if [ ! -d /data/home ]; then
	mkdir -p /data/home
	chown -R user:user /data/home
	chmod 700 /data/home
fi
