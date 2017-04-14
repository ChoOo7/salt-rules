memcached-pkgs:
  pkg.installed:
    - pkgs:
      - memcached
      - php-memcache

/srv/www-admin/html/phpMemcachedAdmin-1.2.2.tar.gz:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/memcached/files/phpMemcachedAdmin-1.2.2.tar.gz
    - unless: ls /srv/www-admin/html/phpMemcachedAdmin

phpMemcachedAdmin-1.2.2.tar.gz:
  cmd.run:
    - name: cd /srv/www-admin/html/ && tar xvf phpMemcachedAdmin-1.2.2.tar.gz && rm phpMemcachedAdmin-1.2.2.tar.gz
    - unless: ls /srv/www-admin/html/phpMemcachedAdmin
    - require: 
      - file: /srv/www-admin/html/phpMemcachedAdmin-1.2.2.tar.gz

/srv/www-admin/html/phpMemcachedAdmin/Config/Memcache.php:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/memcached/files/Memcache.php
    - template: jinja

{{ pillar['php_config_dir'] }}mods-available/php_session_memcache.ini:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/memcached/files/php_session_memcache.ini
    - template: jinja

# SIMLINK
{{ pillar['php_config_dir'] }}apache2/conf.d/php_session_memcache.ini:
  file.symlink:
    - target: ../../mods-available/php_session_memcache.ini

#Cli
{{ pillar['php_config_dir'] }}cli/conf.d/php_session_memcache.ini:
  file.symlink:
    - target: ../../mods-available/php_session_memcache.ini


/etc/memcached.conf:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/memcached/files/memcached.conf
    - template: jinja

memcached:
  service.running:
    - enable: True
    - require:
      - file: /etc/memcached.conf
      - pkg: memcached-pkgs
    - listen:
      - file: /etc/memcached.conf

/etc/munin/custom_memcached_multi_:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/memcached/files/custom_memcached_multi_
    - mode: 755

/usr/share/munin/plugins/memcached_multi_:
  file.symlink:
    - target: /etc/munin/custom_memcached_multi_
    - force: True
    - onlyif: ls /usr/share/munin/plugins

/etc/munin/plugin-conf.d/munin-node-bs-memcached:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/memcached/files/munin-node-bs-memcached
    - template: jinja

munin-node-configure:
  cmd.wait:
    - name: munin-node-configure --suggest --shell 2> /dev/null |grep memcached | /bin/sh
    - listen: 
      - file: /etc/munin/plugin-conf.d/munin-node-bs-memcached

munin-node:
  cmd.wait:
    - name: service munin-node restart
    - listen:
      - file: /etc/munin/plugin-conf.d/munin-node-bs-memcached
    - require:
      - cmd: munin-node-configure
