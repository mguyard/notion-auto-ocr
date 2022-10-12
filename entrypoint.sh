#!/bin/sh

echo "Writing environment variables to /etc/environment"
printenv | grep -v "no_proxy" >> /etc/environment

if [ -z "$SCAN_FREQUENCY" ] 
then
    echo "Running single instance of scan"
    python ocr.py
else
    #echo "Found scan frequency variable, adding crontab"
    #(crontab -l 2>/dev/null; echo "*/$SCAN_FREQUENCY * * * * /usr/local/bin/python ocr.py > output.log") | crontab -
    echo "Testing crontab"
    (crontab -l 2>/dev/null; echo "* * * * * date >/proc/1/fd/1 2>/proc/1/fd/2") | crontab -
    

    echo "Scanning every $SCAN_FREQUENCY minute(s)"
    service cron start & tail -f output.log
fi