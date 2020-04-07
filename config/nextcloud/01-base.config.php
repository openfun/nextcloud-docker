<?php
$CONFIG = array (
  'passwordsalt' => getenv('NEXTCLOUD_PASSWORD_SALT'),
  'secret' => getenv('NEXTCLOUD_SECRET'),
  'trusted_domains' =>
  array (
    0 => getenv('NEXTCLOUD_TRUSTED_DOMAINS') ?: 'localhost',
  ),
  'version' => getenv('VERSION'),
  'debug' => filter_var(getenv('DEBUG') ?: false, FILTER_VALIDATE_BOOLEAN),
  'instanceid' => getenv('INSTANCE_ID'),
  'updatechecker' => filter_var(getenv('UPDATE_CHECKER') ?: false, FILTER_VALIDATE_BOOLEAN),
  'updater.server.url' => getenv('UPDATE_URL') ?: 'https://updates.nextcloud.com/updater_server/',
  'updater.release.channel' => getenv('UPDATE_CHANNEL') ?: 'stable',
);
