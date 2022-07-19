# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook.
4. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`.

## Основная часть
1. Приготовьте свой собственный inventory файл `prod.yml`.
```
---
all:
  children:
    elasticsearch:
       hosts:
         elastic:
            ansible_connection: docker

    kibana:
       hosts:
         kibana:
            ansible_connection: docker
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
```
vars.yml
---
kibana_version: "8.3.2"
kibana_home: "/usr/share/kibana/{{ kibana_version }}"

site.yml
- name: Install Kibana
  hosts: kibana
  tasks:
    - name: Upload tar.gz kibana from remote URL
      get_url:
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        mode: 0755
        timeout: 60
        force: true
        validate_certs: false
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for Kibana
      file:
        state: directory
        path: "{{ kibana_home }}"
      tags: kibana
    - name: Extract kibana in the installation directory
      ansible.builtin.unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/elasticsearch"
      tags:
        - kibana
    - name: Set environment kibana
      template:
        src: templates/kibana.sh.j2
        dest: /etc/profile.d/kibana.sh
      tags: kibana
```
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
   ```
   ошибки отсутсвуют
   ```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
[root@node-2 playbook]# ansible-playbook site.yml --check
[WARNING]: Found both group and host with same name: kibana
[WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in incorrectly calculated text
widths that can cause Display to print incorrect line lengths

PLAY [Install Java] ***************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [kibana]
ok: [elastic]

TASK [Set facts for Java 11 vars] *************************************************************************************
ok: [elastic]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] *****************************************************
ok: [kibana]
ok: [elastic]

TASK [Ensure installation dir exists] *********************************************************************************
ok: [elastic]
ok: [kibana]

TASK [Extract java in the installation directory] *********************************************************************
skipping: [kibana]
skipping: [elastic]

TASK [Export environment variables] ***********************************************************************************
ok: [kibana]
ok: [elastic]

PLAY [Install Elasticsearch] ******************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [elastic]

TASK [Upload tar.gz Elasticsearch from remote URL] ********************************************************************
changed: [elastic]

TASK [Create directrory for Elasticsearch] ****************************************************************************
ok: [elastic]

TASK [Extract Elasticsearch in the installation directory] ************************************************************
skipping: [elastic]

TASK [Set environment Elastic] ****************************************************************************************
ok: [elastic]

PLAY [Install Kibana] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [kibana]

TASK [Upload tar.gz kibana from remote URL] ***************************************************************************
changed: [kibana]

TASK [Create directrory for Kibana] ***********************************************************************************
ok: [kibana]

TASK [Extract kibana in the installation directory] *******************************************************************
skipping: [kibana]

TASK [Set environment kibana] *****************************************************************************************
ok: [kibana]

PLAY RECAP ************************************************************************************************************
elastic                    : ok=9    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
kibana                     : ok=9    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
[root@node-2 playbook]# ansible-playbook site.yml --diff
[WARNING]: Found both group and host with same name: kibana
[WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in incorrectly calculated text
widths that can cause Display to print incorrect line lengths

PLAY [Install Java] ***************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [elastic]
ok: [kibana]

TASK [Set facts for Java 11 vars] *************************************************************************************
ok: [elastic]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] *****************************************************
ok: [elastic]
ok: [kibana]

TASK [Ensure installation dir exists] *********************************************************************************
ok: [elastic]
ok: [kibana]

TASK [Extract java in the installation directory] *********************************************************************
skipping: [elastic]
skipping: [kibana]

TASK [Export environment variables] ***********************************************************************************
ok: [elastic]
ok: [kibana]

PLAY [Install Elasticsearch] ******************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [elastic]

TASK [Upload tar.gz Elasticsearch from remote URL] ********************************************************************
ok: [elastic]

TASK [Create directrory for Elasticsearch] ****************************************************************************
ok: [elastic]

TASK [Extract Elasticsearch in the installation directory] ************************************************************
skipping: [elastic]

TASK [Set environment Elastic] ****************************************************************************************
ok: [elastic]

PLAY [Install Kibana] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [kibana]

TASK [Upload tar.gz kibana from remote URL] ***************************************************************************
ok: [kibana]

TASK [Create directrory for Kibana] ***********************************************************************************
ok: [kibana]

TASK [Extract kibana in the installation directory] *******************************************************************
ok: [kibana]

TASK [Set environment kibana] *****************************************************************************************
ok: [kibana]

PLAY RECAP ************************************************************************************************************
elastic                    : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
kibana                     : ok=10   changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
Изменения не наблюдаются
```
9.  Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.

## Необязательная часть

1. Приготовьте дополнительный хост для установки logstash.
2. Пропишите данный хост в `prod.yml` в новую группу `logstash`.
3. Дополните playbook ещё одним play, который будет исполнять установку logstash только на выделенный для него хост.
4. Все переменные для нового play определите в отдельный файл `group_vars/logstash/vars.yml`.
5. Logstash конфиг должен конфигурироваться в части ссылки на elasticsearch (можно взять, например его IP из facts или определить через vars).
6. Дополните README.md, протестируйте playbook, выложите новую версию в github. В ответ предоставьте ссылку на репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

