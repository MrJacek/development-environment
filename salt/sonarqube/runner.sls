unzip:
  pkg.installed: []
runner-package:
  archive.extracted:
    - name: /opt/sonar-runner
    - source: http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip
    - source_hash: http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip.md5
    - archive_format: zip
    - require:
      - pkg: unzip

sonar-runner-home:
  file.managed:
    - name: /etc/profile.d/sonar-runner.sh
    - source: salt://sonarqube/files/sonar-runner.sh

sonar-runner-link:
  file.symlink:
    - name: /usr/bin/sonar-runner
    - target: /opt/sonar-runner/sonar-runner-2.4/bin/sonar-runner
