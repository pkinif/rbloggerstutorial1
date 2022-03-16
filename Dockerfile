FROM rocker/r-base

# setup nginx
RUN apt-get update && \
	apt-get install -y nginx apache2-utils && \
	htpasswd -bc /etc/nginx/.htpasswd test test 
	
# install R packages
RUN apt install libsodium-dev # required for plumber
RUN install2.r --error plumber


RUN openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/ssl/private/server.key \
		-out /etc/ssl/private/server.crt

ADD ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

ADD . /app
WORKDIR /app

CMD service nginx start && R -e "source('start_api.R')"