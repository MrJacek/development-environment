base:
  '*':
     - vim.salt
     - dns
     - dependency
     - sun-java
     - sun-java.env
     - docker
     - maven
     - maven.env
     - gitlab-runner
     - nexus
     - nexus.nginx
     - postgres
     - postgres.python
     - sonarqube
