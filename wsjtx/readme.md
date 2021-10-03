#Run me like this
xhost +"local:docker@"

 docker run -it --rm \
 --name wsjtx \
 --device /dev/snd:/dev/snd \
 --device /dev/dri \
 --device=/dev/ttyUSB0 \
 -e DISPLAY=unix:0 \
 -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
 -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
 -v $HOME/.config/pulse/cookie:/root/.config/pulse/cookie \
 -v $HOME/volume/.local/share/WSJT-X:/root/.local/share/WSJT-X \
 -v $HOME/volume/.config:/root/.config \
 -v /dev/shm:/dev/shm \
 -v /tmp/.X11-unix:/tmp/.X11-unix \
 -v /run/dbus/:/run/dbus/ \
 -v /dev/shm:/dev/shm \
 --group-add $(getent group audio | cut -d: -f3) \
 hakankoseoglu/wsjtx:latest

