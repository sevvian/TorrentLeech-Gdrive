FROM python:3.8.5-alpine3.12


RUN mkdir ./app
RUN chmod 777 ./app
WORKDIR ./app

#RUN echo -e "http://nl.alpinelinux.org/alpine/v3.12/main\nhttp://nl.alpinelinux.org/alpine/v3.12/community" > /etc/apk/repositories
RUN apk update
#RUN apk add --no-cache py3-pip
RUN apk add --no-cache bash

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

RUN apk add build-base jpeg-dev zlib-dev
ENV LIBRARY_PATH=/lib:/usr/lib

RUN apk add --no-cache py3-pip python3  git aria2 wget curl busybox unzip unrar tar ffmpeg
RUN wget https://rclone.org/install.sh
RUN bash  install.sh

COPY requirements.txt .
#RUN pip3 install wheel
#RUN pip3 install --no-use-pep517  multidict
#RUN pip3 install --no-use-pep517  yarl
RUN apk --update add --virtual build-dependencies libffi-dev gcc musl-dev \
	 && pip install --upgrade pip \
	&& pip install -r requirements.txt \
	&& apk del build-dependencies
RUN pip3 install  -r requirements.txt
VOLUME /config/aria2
COPY ./aria2.conf /config/aria2/aria2.conf
ENV XDG_CONFIG_HOME=/
COPY . .
CMD ["bash","start.sh"]
