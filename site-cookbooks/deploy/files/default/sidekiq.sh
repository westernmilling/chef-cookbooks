#!/bin/bash
# sidekiq    Init script for Sidekiq
# chkconfig: 345 100 75
#
# Description: Starts and Stops Sidekiq message processor for Stratus application.
#
# User-specified exit parameters used in this script:
#
# Exit Code 5 - Incorrect User ID
# Exit Code 6 - Directory not found


# You will need to modify these
AS_USER="deploy"
APP_DIR="/var/www/current"

# APP_CONFIG="$APP_DIR/config"
LOG_FILE="$APP_DIR/log/sidekiq.log"
LOCK_FILE="$APP_DIR/tmp/sidekiq-lock"
PID_FILE="$APP_DIR/tmp/pids/sidekiq.pid"
GEMFILE="$APP_DIR/Gemfile"
SIDEKIQ="sidekiq"
APP_ENV="production"
BUNDLE="bundle"

START_CMD="$BUNDLE exec $SIDEKIQ -e $APP_ENV -P $PID_FILE"
CMD="cd ${APP_DIR}; ${START_CMD} >> ${LOG_FILE} 2>&1 &"

RETVAL=0


start() {

  status
  if [ $? -eq 1 ]; then
    [ -d $APP_DIR ] || (echo "$APP_DIR not found!.. Exiting"; exit 6)
    cd $APP_DIR
    echo "Starting $SIDEKIQ message processor .. "

    if [ "$(id -un)" = "$AS_USER" ]; then
      eval $CMD
    else
      su -c "$CMD" - $AS_USER
    fi

    RETVAL=$?
    #Sleeping for 8 seconds for process to be precisely visible in process table - See status ()
    sleep 8
    [ $RETVAL -eq 0 ] && touch $LOCK_FILE
    return $RETVAL
  else
    echo "$SIDEKIQ message processor is already running .. "
  fi


}

stop() {

  status
  if [ $? -eq 0 ]; then
    echo "Stopping sidekiq message processor .."
    SIG="INT"
    kill -$SIG `cat $PID_FILE`
    RETVAL=$?
    [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
    return $RETVAL
  else
    echo "Sidekiq message processor is stopped already .."
  fi

}

shutdown() {
  status
  if [ $? -eq 0 ]; then
    echo "Shutting down sidekiq message processor .."
    SIG="USR1"
    kill -$SIG `cat $PID_FILE`
    RETVAL=$?
    [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
    return $RETVAL
  else
    echo "Sidekiq message processor is stopped already .."
  fi
}

status() {

  ps -ef | grep 'sidekiq [0-9].[0-9].[0-9]' | grep -v grep
  return $?
}


case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    shutdown)
        shutdown
        ;;
    status)
        status

        if [ $? -eq 0 ]; then
             echo "$SIDEKIQ message processor is running .."
             RETVAL=0
         else
             echo "$SIDEKIQ message processor is stopped .."
             RETVAL=1
         fi
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 0
        ;;
esac
exit $RETVAL
