#!/bin/sh
# Запуск dbus
if command -v dbus-launch >/dev/null 2>&1 && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Автозапуск приложений
dex -a -s /etc/xdg/autostart:/usr/share/autostart:$HOME/.config/autostart

# Запуск DWM
exec dwm