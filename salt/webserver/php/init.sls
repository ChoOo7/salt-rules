
/var/log/php/:
  file.directory:
    - user: www-data

/etc/logrotate.d/apache2:
  file.managed:
    - source: salt://webserver/php/files/logrotate


/etc/logrotate.d/all_symfony_logs:
  file.managed:
    - source: salt://webserver/php/files/logrotate_sf

installPhpPackages:
  pkg.installed:
    - names:
      - mysql-common
      - zlib1g-dev
      - php-dev
      - php-mcrypt
      - php-mysql
      - php-gd
      - php-cli
      - php-curl
      - php-xsl
      - php-json
      - libapache2-mod-php

      - php-pear
      - php-redis
      

      - imagemagick


{% for configName in ['max_execution_time.ini','temp_dir.ini','memory_limit.ini','session_max_lifetime.ini','max_input_time.ini','mysql_allow_persistent.ini','post_max_size.ini','redis.ini', 'default_charset.ini', 'mcrypt.ini'] %}

{{ pillar['php_config_dir'] }}mods-available/{{ configName }}:
  file:
    - managed
    - source: salt://webserver/php/files/conf.d/{{ configName }}
    - template: jinja
    - require:
      - pkg: installPhpPackages

# SIMLINK
{{ pillar['php_config_dir'] }}apache2/conf.d/{{ configName }}:
  file.symlink:
    - target: ../../mods-available/{{ configName }}

#Cli
{{ pillar['php_config_dir'] }}cli/conf.d/{{ configName }}:
  file.symlink:
    - target: ../../mods-available/{{ configName }}
{% endfor %}



{% for configName in ['20-mcrypt.ini', '20-redis.ini'] %}

{{ pillar['php_config_dir'] }}apache2/conf.d/{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}apache2/conf.d/{{ configName }}


{{ pillar['php_config_dir'] }}cli/conf.d/{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}cli/conf.d/{{ configName }}

{% endfor %}


