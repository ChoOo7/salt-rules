
/etc/mysql/conf.d/max_connect_errors.cnf:
  file.managed:
    - source: salt://sql/conf/files/max_connect_errors.cnf

/etc/mysql/conf.d/skip_resolve.cnf:
  file.managed:
    - source: salt://sql/conf/files/skip_resolve.cnf


set/etc/mysql/my.cnf:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://sql/galera/files/my.cnf
    - group: root
    - mode: 644
    - template: jinja


mysqladmin --defaults-file=/etc/mysql/debian.cnf  flush-hosts > /dev/null:
  cron.present:
    - user: root

#Une fois nous avons eu un cas ou les processmysqladmin flushhost s'empilait et on saturé les slot de co disponible. Cette crontab est là pour éviter cela.
autokillmyadinflushhost:
  cron.present:
    - identifier: autokillmyadinflushhost
    - user: root
    - name: sleep 10 && pgrep --signal 9 -f 'mysqladmin --defaults-file=/etc/mysql/debian.cnf  flush-hosts' &> /dev/null
    - minute: 7
