gitlab-dependency:
  pkg.installed:
    - pkgs:
      - curl
      - openssh-server
      - postfix

#  firewall-cmd --permanent --add-service=http

postfix:
  service.running:
    - enable: True
    - require:
      - pkg: gitlab-dependency
sshd:
  service.running:
    - enable: True
    - require:
      - pkg: gitlab-dependency

gitlab-repo:
  cmd.run:
    - name: 'curl -o /tmp/script.rpm.sh  https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh '
    - creates: /tmp/script.rpm.sh
    - require:
      - pkg: gitlab-dependency

'gitlab repo is installed':
  cmd.wait:
    - name: bash /tmp/script.rpm.sh
    - watch:
      - cmd: gitlab-repo

nginx-sonar:
  file.managed:
    - name: /etc/nginx/conf.d/sonar.conf
    - makedirs: True
nginx-nexus:
  file.managed:
    - name: /etc/nginx/conf.d/nexus.conf
    - makedirs: True
gitlab:
  pkg.installed:
    - name: gitlab-ce
    - require:
      - cmd: 'gitlab repo is installed'
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://gitlab/files/gitlab.rb
    - template: jinja
    - context:
        hostname: {{ pillar['envdev']['hostname'] }}
  cmd.wait:
    - name: firewall-cmd --permanent --add-service=http
    - watch:
      - pkg: gitlab

'reload firewall':
  cmd.wait:
    - name: systemctl reload firewalld
    - watch:
      - cmd: gitlab

'gitlab is running':
  cmd.wait:
    - name: gitlab-ctl reconfigure & gitlab-ctl restart nginx
    - watch:
      - file: gitlab
