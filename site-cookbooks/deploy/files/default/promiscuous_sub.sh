#!/bin/bash
# chkconfig: 345 100 75
#
# Description:
#
# User-specified exit parameters used in this script:
#
# Exit Code 5 - Incorrect User ID
# Exit Code 6 - Directory not found


# You will need to modify these
AS_USER="deploy"
APP_DIR="/var/www/current"

# APP_CONFIG="$APP_DIR/config"
LOG_FILE="$APP_DIR/log/promiscuous.log"
LOCK_FILE="$APP_DIR/tmp/promiscuous-lock"
PID_FILE="$APP_DIR/tmp/pids/promiscuous.pid"
GEMFILE="$APP_DIR/Gemfile"
PROMISCUOUS="promiscuous subscribe"
APP_ENV="staging"
BUNDLE="bundle"

START_CMD="RAILS_ENV=$APP_ENV $BUNDLE exec $PROMISCUOUS --daemonize --pid-file $PID_FILE"
CMD="cd ${APP_DIR} && ${START_CMD} >> ${LOG_FILE} 2>&1 &"

RETVAL=0
STATUS_CODE=0

start() {
  local status_code=$(status)

  if [ $status_code -eq 0 ]; then
    [ -d $APP_DIR ] || (echo "$APP_DIR not found!.. Exiting"; exit 6)
    cd $APP_DIR
    echo "Starting $PROMISCUOUS processor .. "

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
    echo "$PROMISCUOUS processor is already running .. "
  fi
}

stop() {
  local status_code=$(status)

  if [ $status_code -eq 1 ]; then
    echo "Stopping $PROMISCUOUS processor .."
    SIG="INT"
    kill -$SIG `cat $PID_FILE`
    RETVAL=$?
    [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
    return $RETVAL
  else
    echo "$PROMISCUOUS processor is stopped already .."
  fi
}

shutdown() {
  local status_code=$(status)
  if [ $status_code -eq 1 ]; then
    echo "Shutting down $PROMISCUOUS processor .."
    SIG="USR1"
    kill -$SIG `cat $PID_FILE`
    RETVAL=$?
    [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
    return $RETVAL
  else
    echo "$PROMISCUOUS processor is stopped already .."
  fi
}

status() {
  local running=$(ps -ef | grep 'promiscuous subscribe' | grep -v grep)
  if [ -z "$running" ]; then
    echo "0"
  else
    echo "1"
  fi
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
        status_code=$(status)
        if [ $status_code -eq 1 ]; then
             echo "$PROMISCUOUS processor is running .."
             RETVAL=0
         else
             echo "$PROMISCUOUS processor is stopped .."
             RETVAL=1
         fi
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 0
        ;;
esac
exit $RETVAL
