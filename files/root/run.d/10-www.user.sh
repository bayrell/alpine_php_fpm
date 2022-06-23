if [ ! -z $WWW_UID ] && [ ! -z $WWW_GID ]; then
	sed -i "s|:800:800:|:$WWW_UID:$WWW_GID:|g" /etc/passwd
	sed -i "s|:800:|:$WWW_GID:|g" /etc/group
fi