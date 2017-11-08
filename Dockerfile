FROM php:7.0-apache

MAINTAINER Loan Lassalle <loan.lassalle@heig-vd.ch>
MAINTAINER Tano Iannetta <tano.iannetta@heig-vd.ch>

COPY ./docs /var/www/html/

RUN chmod -R 755 /var/www/html