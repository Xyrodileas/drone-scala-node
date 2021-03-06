FROM openjdk:8

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt update													&& \
	apt upgrade -y -q												&& \
	echo "deb https://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list                               && \
	curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" |      \
	apt-key add                                                                                                     && \
	apt update                                                                                                      && \
	apt install -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 -y -q sbt		                        && \
	echo 'dash dash/sh select false' | debconf-set-selections							&& \
	dpkg-reconfigure dash								 				&& \
	rm -rf /var/lib/apt/lists

RUN echo "deb-src http://deb.debian.org/debian buster main /" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian buster-updates main /" >> /etc/apt/sources.list

RUN cat etc/apt/sources.list
RUN apt update
RUN apt install -y dpkg-sig lintian fakeroot rpm

RUN \
	wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash				&& \
	. ~/.nvm/nvm.sh								 					&& \
	nvm install --lts												&& \
	npm install -g grunt bower                                                                                      && \
	echo '{"allow_root": true}' > ~/.bowerrc
