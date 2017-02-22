python-software-properties:
  pkg:
      - installed

python-mysqldb:
  pkg:
      - installed

rsync:
  pkg.installed

{% if grains['oscodename'] == 'trusty' or grains['oscodename'] == 'vivid' %}

mariadb-repo:
  pkgrepo.managed:
    - comments:
      - '# MariaDB 5.5 Ubuntu repository list - managed by salt trusty'
      - '# http://mirror.jmu.edu/pub/mariadb/repo/5.5/ubuntu'
#    - name: deb http://mirror3.layerjet.com/mariadb/repo/5.5/ubuntu trusty main
    - name: deb http://mirror.jmu.edu/pub/mariadb/repo/5.5/ubuntu trusty main
    - dist: trusty
    - file: /etc/apt/sources.list.d/mariadb.list
    - keyserver: keyserver.ubuntu.com
    - keyid: '0xcbcb082a1bb943db'
    - require_in:
      - pkg: mariadb-pkgs

apt_update: 
  cmd.run: 
    - name: apt-get update
    - require: 
      - pkgrepo: mariadb-repo

{% set admin_password = pillar['mysql_config']['admin_password'] %}

mariadb-debconf: 
  debconf.set:
    - name: mariadb-galera-server
    - data:
        'mysql-server/root_password': {'type':'string','value':{{ admin_password }}}
        'mysql-server/root_password_again': {'type':'string','value':{{ admin_password }}}
    - unless: ls /etc/mysql/conf.d/galera.cnf

mariadb-pkgs:
  pkg.installed:
    - names:
      - mariadb-galera-server
      - galera-3
      - xtrabackup
      - socat
    - require:
      - pkgrepo: mariadb-repo
      - debconf: mariadb-debconf
      - cmd: apt_update
    - unless: ls /etc/mysql/conf.d/galera.cnf

mysql_stop: 
  service: 
    - name: mysql 
    - dead
    - unless: ls /etc/mysql/conf.d/galera.cnf

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://sql/galera/files/my.cnf
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: mariadb-pkgs
    - unless: ls /etc/mysql/conf.d/galera.cnf

copy:
  cmd.run:
    - names: 
      - cp -a /var/lib/mysql/ /srv/mysql/
      - cp -a /var/log/mysql/ /srv/mysql_log/
    - unless: ls /srv/mysql/ibdata1

/etc/mysql/debian.cnf:
  file.managed:
    - source: salt://sql/galera/files/debian.cnf
    - group: root
    - mode: 664
    - template: jinja
    - unless: ls /etc/mysql/conf.d/galera.cnf

/etc/mysql/conf.d/galera.cnf:
  file:
    - managed
    - source: salt://sql/galera/files/galera.cnf
    - group: root
    - mode: 664
    - template: jinja
    - unless: ls /etc/mysql/conf.d/galera.cnf
    - require:
      - pkg: mariadb-pkgs

{% set nodename = grains['nodename'] %}
{% set node_master = grains['node_master'] %}
{% if nodename == node_master %}
start_wsrep:
  cmd.run:
    - name: /etc/init.d/mysql start --wsrep-new-cluster --wsrep-cluster-address="gcomm://"
    - require: 
      - pkg: mariadb-pkgs
    - unless: ls /var/run/mysqld/mysqld.sock


grantxinetcheckuser:
  cmd.run:
    - name: echo "GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY 'clustercheckpasswordXXXXXX'" | mysql --defaults-file=/etc/mysql/debian.cnf --default-character-set=utf8
  mysql_user.present:
    - name: clustercheckuser
    - host: localhost
    - password: clustercheckpassword!k2t1rvzH
    - connection_default_file: '/etc/mysql/debian.cnf'
    - onlyif: 'ls /etc/mysql/debian.cnf'
    - require:
      - cmd: start_wsrep
      - pkg: python-mysqldb

sql_update_maint:
  cmd.run:
    - name: mysql -u root -p{{ admin_password }} -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '{{ pillar['mysql_config']['maintenance_password'] }}';"
    - require:
      - pkg: mariadb-pkgs


  #mysql_grants.present:
  #  - grant: PROCESS
  #  - database: *.*   #*.* not working - https://github.com/saltstack/salt/issues/26920
  #  - user: clustercheckuser
  #  - host: localhost
  #  - onlyif: 'ls /etc/mysql/debian.cnf'
  #  - require:
  #    - mysql_user: grantxinetcheckuser
  #    - cmd: start_wsrep

{% else %}
start_wsrep:
  cmd.run:
    - name: /etc/init.d/mysql start
    - require:
      - pkg: mariadb-pkgs
    - unless: ls /var/run/mysqld/mysqld.sock  
{% endif %}

{% endif %}
