FROM ubuntu:focal

RUN apt-get update \
 && apt-get upgrade -y

RUN apt-get install --no-install-recommends -y \
    fluxbox           \
    openssl           \
    websockify        \
    x11vnc            \
    xterm             \
    wget             \
    xvfb

# Install Chrome. #

## Set the Chrome repo.
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE 1
RUN apt-get install -y gnupg2
RUN wget --no-check-certificate -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update && apt-get -y install google-chrome-stable


RUN apt autoremove -y

RUN groupadd jubap && mkdir /home/jubap     \
 && useradd -s /bin/bash -g jubap jubap     \
 && cp /etc/skel/.bashrc /home/jubap/.bashrc \
 && echo "cd ~/share" >> /home/jubap/.bashrc


ENV VNC_PASSWD=admin 
COPY ./entrypoint.sh /home/jubap/

EXPOSE 5900

ENTRYPOINT ["/bin/bash", "/home/jubap/entrypoint.sh"]