#!/bin/bash

#path to JSVC
EXEC=/usr/bin/jsvc

#The current Working Directory
BASEDIR=$(dirname $0)

#User Specific variables
JAVA_HOME="/usr/lib/jvm/java-1.7.0-openjdk-amd64"
USER=peter

CLASS_PATH="$BASEDIR/lib/commons-daemon.jar":"$BASEDIR/DaemonsLogger-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
CLASS=ie.dit.LogDaemon
PID=$BASEDIR/logs/logger.pid
LOG_OUT=$BASEDIR/logs/logger.out
LOG_ERR=$BASEDIR/logs/logger.err
LOG_DIR=$BASEDIR/logs

do_exec()
{
    $EXEC -home $JAVA_HOME -cp $CLASS_PATH -user $USER -outfile $LOG_OUT -errfile $LOG_ERR -pidfile $PID $1 $CLASS
    echo "successfull? " $?
}

case "$1" in
    start)

        if [ ! -d "$LOG_DIR" ]; then
            mkdir $LOG_DIR
        fi
        
        echo "Starting LogDaemon......"
        echo "jsvc path         $EXEC"
        echo "JAVA_HOME         $JAVA_HOME"
        echo "Main class        $CLASS"
        echo "Running as user   $USER"
        echo "PID file          $PID"
        echo "Error log         $LOG_ERR"
        echo "STDOUT log        $LOG_OUT"
        do_exec
        echo "...LogDaemon started"
            ;;
        
     stop)
        if [ -f "$PID" ]; then
		    echo "stopping"
        else
            echo "LogDaemon was not started"
        fi
        
        do_exec "-stop"
            ;;

    restart)
        if [ -f "$PID" ]; then
            do_exec "-stop"
            echo "re-starting LogDaemon........."
            do_exec
            echo "LogDaemon re-started.........."
        else
            echo "cannot restart, LogDaemon is not running"
            exit 1
        fi
            ;;
    *)
            echo "usage: daemon {start|stop|restart}" 
            exit 3
            ;;
esac

