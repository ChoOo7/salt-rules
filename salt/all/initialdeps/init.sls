#Do it before highstate else hightime not working
#https://github.com/saltstack/salt/issues/26454
generalStuffInitialDeps:
  pkg.installed:
    - names:
      - apache2
      - mysql-client
      - python-mysqldb


setMysqlConfigToSaltMinion:
  cmd.run:
    - name: "echo mysql.default_file: '/etc/mysql/debian.cnf' >> /etc/salt/minion && /etc/init.d/salt-minion restart"
    - unless:  if [ -z `cat /etc/salt/minion | grep debian.cnf` ]; then unexistantfunctiontohaveerror; fi;
