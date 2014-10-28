#!/bin/bash

# a simple script to generate files of 
# incrementing days and times used to develop the ruby script
COUNTER=0
APPLICATION_LOG='applicationLog.log'
FILE=$APPLICATION_LOG'.2013-04-'
LINE_COUNTER=0
MOVIEVARIABLE=1

while [ $COUNTER -lt 2 ]; do
	
	for i in 0{1..9} {10..15} ; do   
    
    	for j in 0{0..9} {10..23} ; do

    		touch application-logs/$FILE$i-$j

    			while [ $LINE_COUNTER -lt 20 ]; do

    				 echo "2013-04-17 20:42:18,982 [Thread-0] INFO  ie.dit.FileLogger [] - Human Instinct (2002) (TV) $MOVIEVARIABLE" >> application-logs/$FILE$i-$j
    				let LINE_COUNTER=LINE_COUNTER+1
                    let MOVIEVARIABLE=MOVIEVARIABLE+1
                    if [ $MOVIEVARIABLE -gt 3 ]; then
                        let MOVIEVARIABLE=1
                    fi

    			done
    		let LINE_COUNTER=0
    	done
	done

	let COUNTER=COUNTER+1 
	touch application-logs/$APPLICATION_LOG
	touch application-logs/$FILE.tar.gz
	
done
