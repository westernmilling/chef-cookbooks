### BEGIN INIT INFO
# Provides:          unicorn
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Manage unicorn server
# Description:       Start, stop, restart unicorn server for a specific application.
### END INIT INFO
set -e

[ -f /etc/default/puma ] && . /etc/default/puma

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT=/var/www/current
PID=$APP_ROOT/tmp/pids/puma.pid
CMD="cd $APP_ROOT && RAILS_ENV=production bundle exec puma $APP_ROOT/config/puma.rb"
AS_USER=deploy
set -u

OLD_PIN="$PID.oldbin"

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s $OLD_PIN && kill -$1 `cat $OLD_PIN`
}

run () {
  if [ "$(id -un)" = "$AS_USER" ]; then
    eval $1
  else
    su -c "$1" - $AS_USER
  fi
}

case "$1" in
start)
  sig 0 && echo >&2 "Already running" && exit 0
  run "$CMD"
  ;;
stop)
  #sig QUIT && exit 0
  sig TERM && exit 0
  echo >&2 "Not running"
  ;;
force-stop)
  sig TERM && exit 0
  echo >&2 "Not running"
  ;;
restart|reload)
  sig HUP && echo reloaded OK && exit 0
  echo >&2 "Couldn't reload, starting '$CMD' instead"
  run "$CMD"
  ;;
*)
  echo >&2 "Usage: $0 <start|stop|restart|force-stop>"
  exit 1
  ;;
esac
