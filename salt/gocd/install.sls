gocd-repo:
  pkgrepo.managed:
    - humanname: gocd-repo
    - baseurl: http://dl.bintray.com/gocd/gocd-rpm/
    - comments: 
      - '# This repo is managed by Salt.'
gocd-installed:
  pkg.installed:
    - skip_verify: True
    - pkgs:
      - go-server
      - go-agent

go-server:
  file.managed:
    - name: /etc/default/go-server
    - source: salt://gocd/files/go-server
    - template: jinja
  service.running:
    - enable: True
    - require:
      - pkg: gocd-installed
      - file: go-server

go-agent:
  file.managed:
    - name: /etc/default/go-agent
    - source: salt://gocd/files/go-agent
    - template: jinja
  service.running:
    - enable: True
    - require:
      - pkg: gocd-installed
      - file: go-agent
