
/srv/www-admin/html/opc.php:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/www-admin/files/opc.php


/srv/www-admin/html/apc.php:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/www-admin/files/apc.php

/srv/www-admin/html/users.php:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/www-admin/files/users.php

/srv/www-admin/html/phpinfo.php:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/www-admin/files/phpinfo.php
