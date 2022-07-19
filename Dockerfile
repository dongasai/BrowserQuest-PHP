#
# PHP-APACHE 7.4 Dockerfile
#

FROM php:7.4-cli

MAINTAINER Dongasai 1514582970@qq.com
ENV BUILD_DATE "2021年11月03日14:33:46"
RUN apt-get update
RUN apt-get install -y vim wget zip zlib1g-dev  make automake libtool libzip-dev git
#RUN apt-get install -y 
WORKDIR /home
# 安装常用扩展
EXPOSE 8000
EXPOSE 8787
# 安装 oniguruma
ENV ORIGURUMA_VERSION=6.9.6

RUN wget https://github.com/kkos/oniguruma/archive/v${ORIGURUMA_VERSION}.tar.gz -O oniguruma-${ORIGURUMA_VERSION}.tar.gz \
    && tar -zxvf oniguruma-${ORIGURUMA_VERSION}.tar.gz \
    && cd oniguruma-${ORIGURUMA_VERSION} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install

# igbinary redis memcached memcache pdo mysql mysqli 
RUN docker-php-ext-install bcmath mbstring  pdo pdo_mysql mysqli zip;docker-php-ext-enable bcmath mbstring  pdo pdo_mysql mysqli zip;
# igbinary 
RUN pecl install igbinary \
    && docker-php-ext-enable igbinary



#pcntl
RUN  docker-php-ext-install pcntl;docker-php-ext-enable pcntl

# 安装gd
RUN apt-get update && apt-get install -y wget unzip \
        libfreetype6-dev \
        libmcrypt-dev \
        libjpeg-dev \
        libpng-dev \
&& docker-php-ext-configure gd \
&& docker-php-ext-install gd

# 安装protobuf 0.12.4
 RUN wget https://github.com/allegro/php-protobuf/archive/v0.12.4.tar.gz \
    &&  tar -zxvf v0.12.4.tar.gz \
    && cd php-protobuf-0.12.4/ \
    && phpize \
    && ./configure \
    && make && make install

# 安装composer 
RUN wget https://mirrors.aliyun.com/composer/composer.phar \
	&& mv composer.phar /usr/local/bin/composer \
	&& chmod +x /usr/local/bin/composer \
	&& composer config -g repo.packagist composer https://mirrors.aliyun.com/composer


# xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug





COPY php7.ini  /usr/local/etc/php/conf.d/
WORKDIR /var/www/html
COPY composer.json /var/www/html
COPY composer.lock /var/www/html

RUN composer install

COPY . /var/www/html

WORKDIR /var/www/html

CMD ["php","start.php", "start" ]

CMD php start.php start