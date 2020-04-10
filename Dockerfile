ARG NEXTCLOUD_VERSION
FROM nextcloud:${NEXTCLOUD_VERSION}
ARG USER_ID=1000

USER root
# Give the "root" group the same permissions as the "root" user on /etc/passwd
# to allow a user belonging to the root group to add new users; typically the
# docker user (see entrypoint).
RUN chmod g=u /etc/passwd

RUN mv /usr/src/nextcloud /app
COPY config/nextcloud/* /app/config/
RUN chown -R ${USER_ID}:root /app

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN rm -f /usr/local/etc/php/conf.d/opcache-recommended.ini
COPY config/php/* ${PHP_INI_DIR}/conf.d/
COPY config/php-fpm/* /usr/local/etc/php-fpm.d/

COPY bin/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY bin/install.sh /usr/local/bin/install.sh
RUN chown ${USER_ID}:root /usr/local/bin/install.sh

ENV NEXTCLOUD_PHP_FPM_PM=dynamic \
    NEXTCLOUD_PHP_FPM_PM_MAX_CHILDREN=5 \
    NEXTCLOUD_PHP_FPM_PM_START_SERVERS=2 \
    NEXTCLOUD_PHP_FPM_PM_MIN_SPARE_SERVERS=1 \
    NEXTCLOUD_PHP_FPM_PM_MAX_SPARE_SERVERS=3

USER ${USER_ID}

ENTRYPOINT [ "entrypoint.sh" ]
CMD ["php-fpm"]
