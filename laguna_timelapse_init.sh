#! /bin/bash
# /etc/init.d/laguna_timelapse_init.sh
### BEGIN INIT INFO
# Provides:          laguna_timelapse
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

app_name="laguna_timelapse"
SCRIPT="/usr/bin/python3 laguna_timelapse.py"
RUNAS=pi


PIDFILE=/var/run/laguna_timelapse/laguna_timelapse.pid
LOGFILE=/var/log/laguna_timelapse/laguna_timelapse.log

mkdir -p /var/log/$app_name
mkdir -p /var/run/$app_name
chown -R pi:pi /var/log/$app_name
chown -R pi:pi /var/run/$app_name

start() {
    if [ -f $PIDFILE ] && kill -0 $(cat $PIDFILE); then
        echo 'Service already running' >&2
        return 1
    fi
    echo 'Starting service…' >&2
    cd /opt/laguna_timelapse/
    local CMD="$SCRIPT &> \"$LOGFILE\" & echo \$!"
    su -c "$CMD" $RUNAS > "$PIDFILE"

    sleep 2
    PID=$(cat $PIDFILE)
    if pgrep -u $RUNAS -f $NAME > /dev/null
    then
        echo "$NAME is now running, the PID is $PID"
    else
        echo ''
        echo "Error! Could not start $NAME!"
    fi
}

stop() {
    if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
        echo 'Service not running' >&2
        return 1
    fi
    echo 'Stopping service…' >&2
    kill -15 $(cat "$PIDFILE") && rm -f "$PIDFILE"
    echo 'Service stopped' >&2
}

uninstall() {
  echo -n "Are you really sure you want to uninstall this service? That cannot be undone. [yes|No] "
  local SURE
  read SURE
  if [ "$SURE" = "yes" ]; then
    stop
    rm -f "$PIDFILE"
    echo "Notice: log file is not be removed: '$LOGFILE'" >&2
    update-rc.d -f <NAME> remove
    rm -fv "$0"
  fi
}

case "$1" in 
    start)
       start
       ;;
    stop)
       stop
       ;;
    restart)
       stop
       start
       ;;
    status)
       if [ -f $PIDFILE ] && kill -0 $(cat $PIDFILE); then
           echo 'Service already running'
       else
           echo 'Service not running'
       fi
       ;;
    *)
       echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0 