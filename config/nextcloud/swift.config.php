<?php
if (getenv('OBJECTSTORE_SWIFT_HOST')) {
    $CONFIG = array(
        'objectstore' => array(
            'class' => 'OC\\Files\\ObjectStore\\Swift',
            'arguments' => array(
                    'autocreate' => filter_var(getenv('OBJECTSTORE_SWIFT_AUTOCREATE') ?: false, FILTER_VALIDATE_BOOLEAN),
                    'user' => [
                            'name' => getenv('OBJECTSTORE_SWIFT_USERNAME'),
                            'password' => getenv('OBJECTSTORE_SWIFT_PASSWORD'),
                            'domain' => [
                                    'name' => getenv('OBJECTSTORE_SWIFT_DOMAINNAME') ?: 'default'
                            ]
                    ],
                    'serviceName' => getenv('OBJECTSTORE_SWIFT_SERVICENAME'),
                    'region' => getenv('OBJECTSTORE_SWIFT_REGION'),
                    'url' => getenv('OBJECTSTORE_SWIFT_HOST'),
                    'bucket' => getenv('OBJECTSTORE_SWIFT_BUCKET')
            )
        ),
    );
}
