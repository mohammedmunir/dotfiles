
#!/bin/bash

# Allow local root to connect to the X server
xhost +local:root

# Run the Docker container
docker run -it \
    --device /dev/kvm \
    -p 50922:10022 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority:rw \
    -e "DISPLAY=${DISPLAY}" \
    -e GENERATE_UNIQUE=true \
    -e CPU='Haswell-noTSX' \
    -e CPUID_FLAGS='kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on' \
    -e MASTER_PLIST_URL='https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom-sonoma.plist' \
    sickcodes/docker-osx:sonoma

# Remove local root access to the X server after the container stops
# xhost -local:root
#
# trouble shoot
# sudo mount -t cgroup2 none /sys/fs/cgroup
# yay -S  alsa-utils alsa-base
# sudo usermod -aG audio $USER
# xhost +local:$(whoami)
