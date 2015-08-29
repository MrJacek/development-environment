{%- from 'gocd/settings.sls' import gocd with context %}

/etc/nginx/conf.d/gocd.conf:
  file.managed:
    - source: salt://gocd/files/gocd.conf.nginx
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      gocd_server_name: {{ gocd.server_name }}
      gocd_server_port: {{ gocd.server_port }}
      gocd_agent_port: {{ gocd.agent_port }}
