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

check_folder_www () {
	check_folder=$1
	user_owner=`stat -c "%U" $check_folder`
	group_owner=`stat -c "%G" $check_folder`
	if [ "$user_owner" != "www" ] || [ "$group_owner" != "www" ]; then
		chown -R www:www $check_folder
	fi
}
check_folder_www("/data/php")
check_folder_www("/data/home")