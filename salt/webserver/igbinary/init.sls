
installIgBinary:
  pkg.installed:
    - name: php-igbinary



{{ pillar['php_config_dir'] }}mods-available/20-igbinary.ini:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/igbinary/files/20-igbinary.ini


{{ pillar['php_config_dir'] }}apache2/conf.d/20-igbinary.ini:
  file.symlink:
    - target: {{ pillar['php_config_dir'] }}mods-available/20-igbinary.ini


{{ pillar['php_config_dir'] }}cli/conf.d/20-igbinary.ini:
  file.symlink:
    - target: {{ pillar['php_config_dir'] }}mods-available/20-igbinary.ini

