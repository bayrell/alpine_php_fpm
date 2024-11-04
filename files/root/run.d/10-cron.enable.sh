if [ ! "$CRON_ENABLE" = "1" ]; then
	rm /root/run.d/90-cron.sh > /dev/null 2>&1
fi
