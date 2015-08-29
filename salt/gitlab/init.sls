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

gitlab:
  pkg.installed:
    - name: gitlab-ce
    - require:
      - cmd: 'gitlab repo is installed'
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://gitlab/files/gitlab.rb

'gitlab is running':
  cmd.wait:
    - name: gitlab-ctl reconfigure & gitlab-ctl restart nginx
    - watch:
      - file: gitlab
