{% set apacheConfigAvDirectory = '/etc/apache2/conf-available/' %}
{% set apacheConfigEnDirectory = '/etc/apache2/conf-enabled/' %}


apache2modules:
  pkg.installed:
    - name: apache2
  service.running:
    - reload: True
    - name: apache2
    - require:
      - pkg: apache2modules

#Enable apache modules

EnableExpireModule:
  apache_module.enable:
    - name: expires
    - require:
      - pkg: apache2modules

EnableProxyModule:
  apache_module.enable:
    - name: proxy
    - require:
      - pkg: apache2modules

EnableProxyHttpModule:
  apache_module.enable:
    - name: proxy_http
    - require:
      - pkg: apache2modules

EnableExpireRewrite:
  apache_module.enable:
    - name: rewrite
    - require:
      - pkg: apache2modules


EnableStatusModule:
  apache_module.enable:
    - name: status
    - require:
      - pkg: apache2modules


EnableHeadersModule:
  apache_module.enable:
    - name: headers
    - require:
      - pkg: apache2modules

/etc/apache2/mods-available/ssl.conf:
  file.managed:
    - source: salt://webserver/files/ssl.conf
    - require:
      - pkg: apache2modules
