FROM ubuntu:20.04

# User
ENV USERNAME noetic
ENV PASSWORD noetic

LABEL MAINTAINER="javiercont97"

COPY ./scripts /scripts

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y lubuntu-desktop

RUN rm /run/reboot-required*

RUN useradd -m ${USERNAME} -p $(openssl passwd ${PASSWORD})
RUN usermod -aG sudo ${USERNAME}

RUN apt install -y xrdp

RUN adduser xrdp ssl-cert


RUN sed -i '3 a echo "\
export GNOME_SHELL_SESSION_MODE=Lubuntu\\n\
export XDG_SESSION_TYPE=x11\\n\
export XDG_CURRENT_DESKTOP=LXQt\\n\
export XDG_CONFIG_DIRS=/etc/xdg/xdg-Lubuntu:/etc/xdg\\n\
" > ~/.xsessionrc' /etc/xrdp/startwm.sh

EXPOSE 3389

RUN sudo su ${USERNAME}

RUN chmod +x /scripts/install-ros.sh
RUN /scripts/install-ros.sh

RUN sudo apt-get -y -o Dpkg::Options::="--force-overwrite" install --fix-broken

ENTRYPOINT service xrdp start ; bash