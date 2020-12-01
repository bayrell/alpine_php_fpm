
if [ ! -z $ANY_PHP ] && [ "$ANY_PHP" = "1" ]; then
	sed -i 's|%REWRITE_PHP%|try_files $uri $uri/ /index.php?$args;|g' /etc/nginx/sites-available/99-app.conf
	sed -i 's|%LOCATION_PHP%|location ~ \\.php$|g' /etc/nginx/sites-available/99-app.conf
else
	sed -i 's|%REWRITE_PHP%|rewrite ^/. /index.php last;|g' /etc/nginx/sites-available/99-app.conf
	sed -i 's|%LOCATION_PHP%|location /index.php|g' /etc/nginx/sites-available/99-app.conf
fi
