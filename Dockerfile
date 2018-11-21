FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt update													&& \
	apt upgrade -y -q												&& \
	apt install -y -q wget gnupg apt-transport-https git bzip2 rpm build-essential fakeroot devscripts		&& \
	echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu cosmic main' > /etc/apt/sources.list.d/java.list	&& \
	apt-key adv --no-tty --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xC2518248EEA14886			&& \
	echo 'deb https://dl.bintray.com/sbt/debian /' > /etc/apt/sources.list.d/sbt.list				&& \
	apt-key adv --no-tty --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823	&& \
	apt update								 					&& \
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections		&& \
	apt install -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 -y -q oracle-java8-installer sbt		&& \
	echo 'dash dash/sh select false' | debconf-set-selections							&& \
	dpkg-reconfigure dash								 				&& \
	adduser --disabled-password --gecos drone --shell /bin/bash --home /home/drone drone				&& \
	rm -rf /var/lib/apt/lists

USER drone

RUN \
	wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash				&& \
	. ~/.nvm/nvm.sh								 					&& \
	nvm install --lts												&& \
	npm install -g grunt bower
