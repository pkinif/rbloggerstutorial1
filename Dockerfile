FROM rocker/r-base

RUN apt-get update -qq \
    && apt-get -y --no-install-recommends install \
    libsodium-dev \
&& install2.r --error --deps TRUE \
    plumber
    
# setup nginx
RUN apt-get update && \
	apt-get install -y nginx apache2-utils && \
	htpasswd -bc /etc/nginx/.htpasswd test test 

RUN openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/ssl/private/server.key \
		-out /etc/ssl/private/server.crt

ADD ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

ADD . /app
WORKDIR /app

CMD service nginx start && R -e "source('start_api.R')"