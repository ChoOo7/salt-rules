
hosts_file:
  file.managed:
    - name: /etc/hosts
    - source: salt://custom/arengi/hosts/hosts

#   file.append:
#     - name: /etc/hosts
#     - text:
#       - 10.0.0.2 arengi-back1
#       - 10.0.0.3 arengi-back2
#       - 10.0.0.4 arengi-back3
