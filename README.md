# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
   ```
   ok: [localhost] => {
    "msg": 12
    }
   ```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
   ```
   Выполнено
   ```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.   
    ```
   Выполнено
   ```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
   ```
    TASK [Print fact] *************************************************************************************************************************************************************************************************
    ok: [4be14c27ab9b] => {
        "msg": "deb"
    }
    ok: [4105a9d93859] => {
        "msg": "el"
    }

    PLAY RECAP ********************************************************************************************************************************************************************************************************
    4105a9d93859               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    4be14c27ab9b               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
    ```
   Выполнено
   ```
    
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
    ```
    TASK [Print fact] *************************************************************************************************************************************************************************************************
    ok: [4105a9d93859] => {
        "msg": "el default fact"
    }
    ok: [4be14c27ab9b] => {
        "msg": "deb default fact"
    }

    PLAY RECAP ********************************************************************************************************************************************************************************************************
    4105a9d93859               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    4be14c27ab9b               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
   ```
   [root@node-2 deb]# ansible-vault encrypt examp.yml
    New Vault password:
    Confirm New Vault password:
    Encryption successful
    [root@node-2 deb]# cat examp.yml
    $ANSIBLE_VAULT;1.1;AES256
    37626566343762353266666538353461383430613166356264343233393266653033663538643530
    6566623163326131626165313834643239333338313663630a333731363333613934613865356235
    36623333326161613461343031376137373936636663393662373433636565666230373931633564
    3632346237336261370a316463643935363364346537623533326364653230383137333737643135
    66386133383938646563613865373539613461383635343337363365363365383462656432616266
    6532326137643333313962313562326535626637393533633561

    [root@node-2 group_vars]# ansible-vault encrypt ./el/examp.yml
    New Vault password:
    Confirm New Vault password:
    Encryption successful
    [root@node-2 group_vars]# cat el/examp.yml
    $ANSIBLE_VAULT;1.1;AES256
    37326161616230393934383566363536653132653863623465346537323263353262316566373638
    6133653732373164663438366135633763333235613631370a343464353031376137356361393236
    33343834373661386562373536396534626534666361633964656434396566333764636662626530
    3832646363303939630a613264633265376166633338643434356165303563646432633336346231
    30333839316438666535623431343432623562376666653933633565313039353032663166666336
    3362326432636537616464326237636630393335646235613765
   ```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
   ```
   Пароль не запрашивался, решил путем создания файла с паролем
   [root@node-2 playbook]# ansible-playbook -i ./inventory/prod.yml site.yml --vault-password-fil ./group_vars/ansible_pass.txt
    [WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in
    incorrectly calculated text widths that can cause Display to print incorrect line lengths

    PLAY [Print os facts] *************************************************************************

    TASK [Gathering Facts] ************************************************************************
    [WARNING]: Distribution debian 11 on host 4be14c27ab9b should use /usr/bin/python3, but is
    using /usr/bin/python3.9, since the discovered platform python interpreter was not present.
    See https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html
    for more information.
    ok: [4be14c27ab9b]
    ok: [4105a9d93859]

    TASK [Print OS] *******************************************************************************
    ok: [4105a9d93859] => {
        "msg": "CentOS"
    }
    ok: [4be14c27ab9b] => {
        "msg": "Debian"
    }

    TASK [Print fact] *****************************************************************************
    ok: [4105a9d93859] => {
        "msg": "el default fact"
    }
    ok: [4be14c27ab9b] => {
        "msg": "deb default fact"
    }

    PLAY RECAP ************************************************************************************
    4105a9d93859               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    4be14c27ab9b               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

    ```
9.  Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```
ansible-doc -t connection -l

local                          execute on controller
```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
```
---
  el:
    hosts:
      4105a9d93859:
        ansible_connection: docker
  deb:
    hosts:
      4be14c27ab9b:
        ansible_connection: docker
  localhost:
    hosts:
      local:
        ansible_connection: local
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```
[root@node-2 playbook]# ansible-playbook -i ./inventory/prod.yml site.yml --vault-password-file ./group_vars/ansible_pass.txt
[WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in incorrectly calculated text
widths that can cause Display to print incorrect line lengths

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
[DEPRECATION WARNING]: Distribution centos 8.5.2111 on host local should use /usr/libexec/platform-python, but is using
 /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See https://docs.ansible.com/ansible-
core/2.11/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version
 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [local]
[WARNING]: Distribution debian 11 on host 4be14c27ab9b should use /usr/bin/python3, but is using /usr/bin/python3.9,
since the discovered platform python interpreter was not present. See https://docs.ansible.com/ansible-
core/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [4be14c27ab9b]
ok: [4105a9d93859]

TASK [Print OS] ********************************************************************************************************
ok: [local] => {
    "msg": "CentOS"
}
ok: [4105a9d93859] => {
    "msg": "CentOS"
}
ok: [4be14c27ab9b] => {
    "msg": "Debian"
}

TASK [Print fact] ******************************************************************************************************
ok: [local] => {
    "msg": "all default fact"
}
ok: [4be14c27ab9b] => {
    "msg": "deb default fact"
}
ok: [4105a9d93859] => {
    "msg": "el default fact"
}

PLAY RECAP *************************************************************************************************************
4105a9d93859               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
4be14c27ab9b               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
local                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
```
[root@node-2 group_vars]# ansible-vault decrypt ./deb/examp.yml
Vault password:
Decryption successful
[root@node-2 group_vars]# ansible-vault decrypt ./el/examp.yml
Vault password:
Decryption successful
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
```
[root@node-2 playbook]# ansible-playbook -i ./inventory/prod.yml site.yml
[WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in incorrectly calculated text
widths that can cause Display to print incorrect line lengths

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
[DEPRECATION WARNING]: Distribution centos 8.5.2111 on host local should use /usr/libexec/platform-python, but is using
 /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See https://docs.ansible.com/ansible-
core/2.11/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version
 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [local]
[WARNING]: Distribution debian 11 on host 4be14c27ab9b should use /usr/bin/python3, but is using /usr/bin/python3.9,
since the discovered platform python interpreter was not present. See https://docs.ansible.com/ansible-
core/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [4be14c27ab9b]
ok: [ba22dfd41fc5]
ok: [4105a9d93859]

TASK [Print OS] ********************************************************************************************************
ok: [local] => {
    "msg": "CentOS"
}
ok: [4105a9d93859] => {
    "msg": "CentOS"
}
ok: [4be14c27ab9b] => {
    "msg": "Debian"
}
ok: [ba22dfd41fc5] => {
    "msg": "Fedora"
}

TASK [Print fact] ******************************************************************************************************
ok: [local] => {
    "msg": "all default fact"
}
ok: [4105a9d93859] => {
    "msg": "el default fact"
}
ok: [4be14c27ab9b] => {
    "msg": "deb default fact"
}
ok: [ba22dfd41fc5] => {
    "msg": "fedora default fact"
}

PLAY RECAP *************************************************************************************************************
4105a9d93859               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
4be14c27ab9b               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ba22dfd41fc5               : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
local                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```
#!/bin/bash

set -e

deb=$(docker images | grep bitnami | awk '{print $1}')
echo $deb && docker run -dti --name debian $deb

cent=$(docker images | grep "centos" | awk '{print $1}')
echo $cent && docker run -dti --name centos $cent

fed=$(docker images | grep fedora | awk '{print $1}')
echo $fed && docker run -dti --name fedora $fed

docker ps

ansible-playbook -i inventory/prod.yml site.yml

docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)



[root@node-2 playbook]# ./script.sh
bitnami/python
199c84d4d631bde7d3e17b24b40c8965541de90b479d6074734e110f726c9035
centos
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Already exists
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
10d59665a881391595c350a037619396fa5d6d43991d0bcb87bd1bd821fbd07b
pycontribs/fedora
c143b68cf7361fbaf1e6327ff3e91bfe6bd08c174818117efb665a4388d7b59a
CONTAINER ID   IMAGE               COMMAND       CREATED         STATUS                  PORTS      NAMES
c143b68cf736   pycontribs/fedora   "/bin/bash"   2 seconds ago   Up Less than a second              fedora
10d59665a881   centos              "/bin/bash"   4 seconds ago   Up 2 seconds                       centos
199c84d4d631   bitnami/python      "python"      8 seconds ago   Up 6 seconds            8000/tcp   debian
[WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in incorrectly calculated text widths that can cause Display to print incorrect line lengths

PLAY [Print os facts] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution centos 8.5.2111 on host local should use /usr/libexec/platform-python, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible
release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html for more information. This feature will
 be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [local]
[WARNING]: Distribution debian 11 on host debian should use /usr/bin/python3, but is using /opt/bitnami/python/bin/python, since the discovered platform python interpreter was not present. See
https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [debian]
ok: [fedora]
ok: [centos]

TASK [Print OS] ***************************************************************************************************************************************************************************************************
ok: [local] => {
    "msg": "CentOS"
}
ok: [debian] => {
    "msg": "Debian"
}
ok: [centos] => {
    "msg": "CentOS"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] *************************************************************************************************************************************************************************************************
ok: [local] => {
    "msg": "all default fact"
}
ok: [centos] => {
    "msg": "centos default fact"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}
ok: [debian] => {
    "msg": "deb default fact"
}

PLAY RECAP ********************************************************************************************************************************************************************************************************
centos                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
debian                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
local                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

c143b68cf736
10d59665a881
199c84d4d631
c143b68cf736
10d59665a881
199c84d4d631

```
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
