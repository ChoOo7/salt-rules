php5_ppa_cmd:
  cmd.run:
    - name: "apt-add-repository -y ppa:ondrej/php"
    - env:
      - LC_ALL: 'en_US.UTF-8'

#php5_ppa:
#  pkgrepo.managed:
#    - ppa: ondrej/php5
#    - require:
#      - cmd: php5_ppa_cmd
      
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
      - zlib1g-dev
      - php5.6-mcrypt
      - php5.6-mysql
      - php5.6-gd
      - php5.6-cli
      - php5.6-zip
      - php5.6-ldap
      - php5.6-intl
      - php5.6-curl
      - php5.6-xsl
      - php5.6-json
      - libapache2-mod-php5.6

      - php5.6-redis
      

      - imagemagick

#sometime fails
installPhpPackagesOther:
  pkg.installed:
    - names:
      - php-pear

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


{% for configName in ['mysqlnd.ini', 'xml.ini'] %}

# SIMLINK
{{ pillar['php_config_dir'] }}apache2/conf.d/10-{{ configName }}:
  file.symlink:
    - target: ../../mods-available/{{ configName }}

#Cli
{{ pillar['php_config_dir'] }}cli/conf.d/10-{{ configName }}:
  file.symlink:
    - target: ../../mods-available/{{ configName }}
    

{{ pillar['php_config_dir'] }}apache2/conf.d/{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}apache2/conf.d/{{ configName }} 
    
{{ pillar['php_config_dir'] }}cli/conf.d/{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}cli/conf.d/{{ configName }} 
    
{{ pillar['php_config_dir'] }}apache2/conf.d/15-{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}apache2/conf.d/15-{{ configName }} 
    
{{ pillar['php_config_dir'] }}cli/conf.d/15-{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}cli/conf.d/15-{{ configName }} 
    
{% endfor %}



{% for configName in ['gd.ini', 'json.ini', 'memcache.ini', 'mysql.ini', 'pdo_mysql.ini', 'xsl.ini', 'exif.ini', 'readline.ini', 'curl.ini', 'iconv.ini', 'opcache.ini', 'ftp.ini', 'igbinary.ini', 'mysqli.ini', 'ldap.ini', 'zip.ini'] %}

# SIMLINK
{{ pillar['php_config_dir'] }}apache2/conf.d/{{ configName }}:
  file.symlink:
    - target: ../../mods-available/{{ configName }}

{{ pillar['php_config_dir'] }}apache2/conf.d/20-{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}apache2/conf.d/20-{{ configName }} 
    
{{ pillar['php_config_dir'] }}apache2/conf.d/10-{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}apache2/conf.d/10-{{ configName }} 

{{ pillar['php_config_dir'] }}cli/conf.d/20-{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}cli/conf.d/20-{{ configName }} 

{{ pillar['php_config_dir'] }}cli/conf.d/10-{{ configName }}:
  file.absent:
    - name: {{ pillar['php_config_dir'] }}cli/conf.d/10-{{ configName }} 

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


