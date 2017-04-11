#!/bin/bash

#./compress_all_apachelog.sh  |tee ./compress_all_apachelog.log 2>> ./compress_all_apachelog.err

VERBOSE=$1
TODAY=`date +%Y-%m-%d`
for i in /srv/www/*
do
    [ ! -d $i ] && continue
    [ ! -d $i/logs ] && continue
    echo ""
    echo $i
    cd $i/logs
    #for THEFILE in 20*/* admin/20*/* services/20*/* services-public/20*/* content/20*/* front/20*/* greetings/20*/* web/20*/*
    for THEFILE in 20*/*.log */20*/*.log
    do
	if [ -d $THEFILE ]; then
	    echo "DIRECTORY $THEFILE" >&2
	    echo "DIRECTORY $THEFILE"
	fi
	if [[ $THEFILE == *$TODAY* ]]
	then
	    [ ! -z $VERBOSE ] && echo "contains date $THEFILE jump"
	    continue
	fi

	if [[ $THEFILE == "20*/*.log" ]]; then
		 echo "No log ! "
		 continue
	fi

	if [[ $THEFILE == "*/20*/*.log" ]]; then
		 echo "No log ! "
		 continue
	fi

	if [[ $THEFILE == "20*/*.log" ]]; then
                     echo "No log ! "
                     continue
                fi

                if [[ $THEFILE == "*/20*/*.log" ]]; then
                     echo "No log ! "
                     continue
                fi


	if [[ $THEFILE == *.log ]]; then
	    if [ -e $THEFILE.gz ]; then
		echo "compressed file already exists $i/logs/$THEFILE.gz" >&2
		echo "compressed file already exists $THEFILE.gz"
		echo rm -v $i/logs/$THEFILE >> /tmp/del_unusedlogs
		continue
	    fi
	    echo gzip $THEFILE
	    gzip $THEFILE
	fi
    done

done
[ -f /tmp/del_unusedlogs ] && echo "fichier de suppression /tmp/del_unusedlogs"
