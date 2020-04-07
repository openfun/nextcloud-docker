#!/bin/bash
set -eu

if [ -f "/tmp/nextcloud/installed" ]; then
    echo "already installed"
    exit 0
fi

echo "New nextcloud instance"
if [ -n "${NEXTCLOUD_ADMIN_USER+x}" ] && [ -n "${NEXTCLOUD_ADMIN_PASSWORD+x}" ]; then
    touch /app/config/config.php
    install_options="-n --admin-user \"${NEXTCLOUD_ADMIN_USER}\" --admin-pass \"${NEXTCLOUD_ADMIN_PASSWORD}\""
    if [ -n "${NEXTCLOUD_TABLE_PREFIX+x}" ]; then
        install_options="${install_options} --database-table-prefix \"${NEXTCLOUD_TABLE_PREFIX}\""
    else
        install_options="${install_options} --database-table-prefix \"\""
    fi
    if [ -n "${NEXTCLOUD_DATA_DIR+x}" ]; then
        install_options="$install_options --data-dir \"${NEXTCLOUD_DATA_DIR}\""
    fi

    install_options="${install_options} --database pgsql --database-name \"${POSTGRES_DB}\" --database-user \"${POSTGRES_USER}\" --database-pass \"${POSTGRES_PASSWORD}\" --database-host \"${POSTGRES_HOST}\""

    echo "starting nexcloud installation"
    max_retries=10
    try=0

    until sh -c "php /app/occ maintenance:install ${install_options}" || [ "${try}" -gt "${max_retries}" ]
        do
            echo "retrying (${try} on ${max_retries})"
            try=$((try+1))
            sleep 3s
        done

    if [ "${try}" -gt "${max_retries}" ]; then
        echo "Installation of nextcloud failed!"
        exit 1
    fi

    php /app/occ app:enable user_saml

    touch /tmp/nextcloud/installed

else
    echo "To install nextcloud, please provide admin and databases info"
    exit 1
fi
