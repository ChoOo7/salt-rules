
apache2defaultvhost:
  pkg.installed:
    - name: apache2

  service.running:
    - name: apache2
    - require:
      - pkg: apache2defaultvhost

/srv/www/_default_/html/index.php:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/files/default_index.php

/etc/apache2/httpd.conf:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/defaultvhost/files/httpd.conf


/etc/bash_completion.d/apache2.2-common:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/files/bash_completion_apache2

/etc/apache2/conf.d/javascript-common.conf:
  file:
    - absent


/srv/www/_default_/html/alive.php:
  file:
    - managed
    - source: salt://webserver/files/is_alive.php


{% for configName in ['000-default', '000-default.conf','default_ssl','default'] %}

/etc/apache2/sites-enabled/{{ configName }}:
  file.absent: []

{% endfor %}


/srv/www/_default_/logs/empty:
  file.directory:
    - makedirs: True


/srv/www/_default_/html/robots.txt:
  file.managed:
    - makedirs: True
    - source: salt://webserver/defaultvhost/files/robots_disallow.txt


#Managing default vhost
{% for configName in ['000_default.conf', '001_www-admin.conf'] %}
/etc/apache2/sites-available/{{ configName }}:
  file.managed:
    - source: salt://webserver/defaultvhost/files/{{ configName }}
    - template: jinja



/etc/apache2/sites-enabled/{{ configName }}:
  file.symlink:
    - target: ../sites-available/{{ configName }}
{% endfor %}



