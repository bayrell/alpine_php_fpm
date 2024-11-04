if [ ! -z $MYSQL_HOST ] && [ ! -z $MYSQL_LOGIN ] && [ ! -z $MYSQL_PASSWORD ] && [ ! -z $MYSQL_DATABASE ]; then
	echo "" > /etc/my.cnf.d/client.cnf
	echo "[client]" >> /etc/my.cnf.d/client.cnf
	echo "user=$MYSQL_LOGIN" >> /etc/my.cnf.d/client.cnf
	echo "password=$MYSQL_PASSWORD" >> /etc/my.cnf.d/client.cnf
	echo "host=$MYSQL_HOST" >> /etc/my.cnf.d/client.cnf
	echo "database=$MYSQL_DATABASE" >> /etc/my.cnf.d/client.cnf
fi
