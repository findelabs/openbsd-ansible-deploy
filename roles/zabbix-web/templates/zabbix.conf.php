<?php
// Zabbix GUI configuration file.
global $DB, $HISTORY;

$DB['TYPE']                             = 'POSTGRESQL';
$DB['SERVER']                   = '{{ zabbix_postgres_ip';
$DB['PORT']                             = '5432';
$DB['DATABASE']                 = 'zabbix';
$DB['USER']                             = '{{ zabbix_username }}';
$DB['PASSWORD']                 = '{{ zabbix_password }}';
// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA']                   = '';

$ZBX_SERVER                             = 'localhost';
$ZBX_SERVER_PORT                = '10051';
$ZBX_SERVER_NAME                = '';

$IMAGE_FORMAT_DEFAULT   = IMAGE_FORMAT_PNG;
