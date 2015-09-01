sonar-repo:
  cmd.run:
    - name: curl -o /etc/yum.repos.d/sonar.repo http://skylink.dl.sourceforge.net/project/sonar-pkg/rpm/sonar.repo
    - creates: /etc/yum.repos.d/sonar.repo

sonar:
  pkg.installed:
    - require:
      - cmd: sonar-repo
  file.managed:
    - name: /opt/sonar/conf/sonar.properties
    - source: salt://sonarqube/files/sonar.properties
    - require:
      - pkg: sonar

pmd:
  file.managed:
    - name: /opt/sonar/extensions/plugins/sonar-pmd-plugin-2.4.1.jar
    - source: http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-pmd-plugin/2.4.1/sonar-pmd-plugin-2.4.1.jar
    - source_hash: http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-pmd-plugin/2.4.1/sonar-pmd-plugin-2.4.1.jar.md5
    - require:
      - file: sonar
checkstyle:
  file.managed:
    - name: /opt/sonar/extensions/plugins/sonar-checkstyle-plugin-2.3.jar
    - source: http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-checkstyle-plugin/2.3/sonar-checkstyle-plugin-2.3.jar
    - source_hash: http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-checkstyle-plugin/2.3/sonar-checkstyle-plugin-2.3.jar.md5
    - require:
      - file: sonar

findbugs:
  file.managed:
    - name: /opt/sonar/extensions/plugins/sonar-findbugs-plugin-3.2.jar
    - source: http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-findbugs-plugin/3.2/sonar-findbugs-plugin-3.2.jar
    - source_hash: http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-findbugs-plugin/3.2/sonar-findbugs-plugin-3.2.jar.md5
    - require:
      - file: sonar

sonar-running:
  service.running:
    - name: sonar
    - enable: True
    - require:
      - pkg: sonar
      - file: sonar
      - file: checkstyle
      - file: pmd
      - file: findbugs
