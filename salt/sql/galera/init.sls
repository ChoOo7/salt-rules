python-software-properties:
  pkg:
      - installed

python-mysqldb:
  pkg:
      - installed

rsync:
  pkg.installed

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


/root/salt/tmp/mariadb-galera.deb:
  file.managed:
    - source: salt://sql/galera/files/mariadb-galera-server-5.5_5.5.42+maria-1~wheezy_amd64.deb
    - makedirs: True
    

removeSomePackages: 
  pkg.purged:
    - names:
      - mysql-client-5.7
      - mysql-client-core-5.7
    - onlyif: dpkg -s mysql-client-5.7

    
installPackages: 
  pkg.installed:
    - names: 
      - libmariadbclient18
      - mariadb-client-core-5.5
      - mariadb-client-5.5
      - libterm-readkey-perl
      - libhtml-template-perl
      - iproute
      - mariadb-common
  
{% set admin_password = pillar['mysql_config']['admin_password'] %}

mariadb-debconf: 
  debconf.set:
    - name: mariadb-galera-server
    - data:
        'mysql-server/root_password': {'type':'string','value':{{ admin_password }}}
        'mysql-server/root_password_again': {'type':'string','value':{{ admin_password }}}
    - unless: ls /etc/mysql/conf.d/galera.cnf


installMariaDb:
  cmd.run:
    - name: dpkg -i /root/salt/tmp/mariadb-galera.deb 
    - unless: dpkg -s mariadb-galera-server-5.5
    - require:
      - file: /root/salt/tmp/mariadb-galera.deb


debugInstall:
  cmd.run:
    - name: apt-get -f install -y


mariadb-pkgs-main:
  pkg.installed:
    - names:
      - mariadb-galera-server
    - unless: dpkg -s mariadb-galera-server-5.5 || dpkg -s mariadb-galera-server

mariadb-pkgs:
  pkg.installed:
    - names:
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


/etc/init.d/mysql:
  file.managed:
    - source: salt://sql/galera/files/mysql_start
    - group: root
    - mode: 755
    
copy:
  cmd.run:
    - names: 
      - cp -a /var/lib/mysql/ /srv/mysql/
      - cp -a /var/log/mysql/ /srv/mysql_log/
    - unless: ls /srv/mysql/ibdata1
    - onlyif: ls /srv/mysql/ && ls /srv/mysql_log/

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

{% if grains['is_node_master'] %}
start_wsrep:
  cmd.run:
    #- name: /etc/init.d/mysql start --wsrep-new-cluster --wsrep-cluster-address="gcomm://"
    - name: /etc/init.d/mysql startcluster
    - require: 
      - pkg: mariadb-pkgs
    - unless: ls /var/run/mysqld/mysqld.sock && ps aux | grep mysql | grep -v grep


grantxinetcheckuser:
  cmd.run:
    - name: echo "GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY 'clustercheckpassword{{ pillar['mysql_config']['haproxy_password'] }}'" | mysql -u root -p{{ admin_password }}  --default-character-set=utf8
  mysql_user.present:
    - name: clustercheckuser
    - host: localhost
    - password: clustercheckpassword!clustercheckpassword{{ pillar['mysql_config']['haproxy_password'] }}
    - connection_user: root
    - connection_pass: {{ admin_password }} 
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
