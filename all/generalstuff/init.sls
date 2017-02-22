

generalStuff:
  pkg.installed:
    - names:
      - screen
      - bzip2
      - emacs
      - php-elisp
      - unzip
      - zip
      - subversion
      - git-core
      - ntpdate
      - pciutils
      - strace
      - htop
      - moreutils
      - mlocate
      - mc
      - ccze
      - pv
      - binutils
      - tmux
      - tshark
      - bmon
      - tcpdump
      - curl
      - wget
      - dnsutils
      - lynx
      - curl
      - python-simplejson
      - expect
      - mutt
      - passwd
      - makepasswd
      - cronolog
      - smem
      - sysstat


uninstallSomePackets:
  pkg.purged:
    - names:
      - command-not-found
      - mlocate
      - atop

/etc/sysctl.conf:
  file.managed:
    - name: /etc/sysctl.conf
    - source: salt://all/generalstuff/files/sysctl.conf
