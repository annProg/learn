hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://hosts
    