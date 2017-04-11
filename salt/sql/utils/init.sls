libterm-readkey-perl:
  pkg.installed
libio-socket-ssl-perl:
  pkg.installed

/root/salt/tmp/percona-toolkit_2.2.16-1_all.deb:
  file:
    - managed
    - source: salt://sql/utils/files/percona-toolkit_2.2.16-1_all.deb
    - makedirs: True
    - require:
      - pkg: libterm-readkey-perl


installPerconaTK:
  cmd.run:
    - name: dpkg -i /root/salt/tmp/percona-toolkit_2.2.16-1_all.deb
    - unless: dpkg -s percona-toolkit
    - require:
      - file: /root/salt/tmp/percona-toolkit_2.2.16-1_all.deb

