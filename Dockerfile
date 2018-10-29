FROM ubuntu:18.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq wget git unzip nginx \
    php7.2-fpm php7.2-gd php7.2-mysql php7.2-mbstring php-imagick \
    imagemagick libimage-exiftool-perl ufraw-batch supervisor

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Replace php-fpm configuration
RUN sed -i -e "s/output_buffering\s*=\s*4096/output_buffering = Off/g" /etc/php/7.2/fpm/php.ini
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.2/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 1G/g" /etc/php/7.2/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 1G/g" /etc/php/7.2/fpm/php.ini
RUN sed -i -e "s:;\s*session.save_path\s*=\s*\"N;/path\":session.save_path = /tmp:g" /etc/php/7.2/fpm/php.ini

# Configure nginx
RUN mkdir /run/php
RUN chown www-data:www-data /var/www
RUN rm /etc/nginx/sites-enabled/*
RUN rm /etc/nginx/sites-available/*
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD conf/php.conf /etc/nginx/
ADD conf/lychee /etc/nginx/sites-enabled/

# Install Lychee
WORKDIR /var/www
RUN git clone https://github.com/jahurtado/Lychee.git lychee
WORKDIR /var/www/lychee
RUN git checkout nikon-nef-support
WORKDIR /var/www

RUN chown -R www-data:www-data /var/www/lychee
RUN chmod -R 770 /var/www/lychee
RUN rm -rf /var/www/lychee/uploads
RUN rm -rf /var/www/lychee/data
RUN mkdir /uploads
RUN mkdir /data
RUN chown www-data:www-data /uploads
RUN chown www-data:www-data /data

EXPOSE 80

WORKDIR /
RUN ln -s /uploads /var/www/lychee/uploads 
RUN ln -s /data /var/www/lychee/data

VOLUME /uploads
VOLUME /data

ENV PUID=1000
ENV PGID=1000

ADD conf/supervisord.conf /etc/supervisor/supervisord.conf
ADD conf/entry-point.sh /entry-point.sh
RUN chmod 777 /entry-point.sh

ENTRYPOINT [ "bash", "-c", "/entry-point.sh" ]
