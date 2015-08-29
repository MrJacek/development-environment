runner-repo:
  cmd.run:
    - name: 'curl -o /tmp/repo-runner.rpm.sh https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.rpm.sh'
    - creates: /tmp/repo-runner.rpm.sh

'runner repo is installed':
  cmd.wait:
    - name: bash /tmp/repo-runner.rpm.sh
    - watch:
      - cmd: runner-repo

runner:
  pkg.installed:
    - name: gitlab-ci-multi-runner
    - require:
      - cmd: 'runner repo is installed'
      - pkg: docker

runner-registered:
  cmd.wait:
    - name: 'gitlab-ci-multi-runner register -n -r f5baa857fb87ccf74266 -u http://ci.centos7.jh.pl'
    - watch:
      - pkg: runner
    - require:
      - cmd: 'gitlab is running'

