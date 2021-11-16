* Configured hostname is not fully qualified.

Log file

```
$ cat /home/stack/undercloud_install.log
/usr/lib64/python3.6/site-packages/_yaml/__init__.py:23: DeprecationWarning: The _yaml extension module is now located at yaml._yaml and its location is subject to change.  To use the LibYAML-based parser and emitter, import from `yaml`: `from yaml import CLoader as Loader, CDumper as Dumper`.
  DeprecationWarning
Deprecated: Option "ipxe_deploy" from group "DEFAULT" is deprecated. Use option "ipxe_enabled" from group "DEFAULT".
Configured hostname is not fully qualified.
An error occurred during configuration validation, please check your host configuration and try again. Error message: Configured hostname is not fully qualified.
```

workaround

```
ssh  -F ~/.quickstart/ssh.config.ansible undercloud "sudo hostnamectl set-hostname undercloud.tripleodomain"
```

workaround 2:

Add this section to config/general_config/featureset054.yml

```
undercloud_cloud_domain: "localdomain"
undercloud_undercloud_hostname: "undercloud.{{ undercloud_cloud_domain }}"
```

* tripleo Wait for cloud-init to finish, if enabled | undercloud

- https://bugs.launchpad.net/tripleo/+bug/1913675
- https://review.opendev.org/c/openstack/tripleo-quickstart/+/773294
- https://opendev.org/openstack/tripleo-heat-templates/commit/c0c29604c1aafb94ec84c456d01cb1865732755a

workaround:

```
sed -i 's/undercloud_setup: true/undercloud_setup: false/' config/general_config/featureset054.yml
```

* None: Max retries exceeded with url: /v2/ (Caused
 by None)

```
2021-11-15 15:44:47.336314 | 00b224a5-0947-2b81-da3c-000000000098 |     TIMING | External deployment step 1 | undercloud | 0:01:44.731512 | 0.01s
2021-11-15 15:44:47.364620 | 00b224a5-0947-2b81-da3c-000000000099 |     TIMING | include_tasks | undercloud | 0:01:44.759814 | 0.01s
2021-11-15 15:44:47.377902 | f0625013-6bf0-467e-bdcc-d4d83c6f3d4e |   INCLUDED | /home/stack/tripleo-deploy/undercloud/undercloud-ansible-dhn0twpd/external_deploy_steps_tasks_step1.yaml | undercloud
2021-11-15 15:44:47.394048 | 00b224a5-0947-2b81-da3c-000000000dc4 |       TASK | Container image prepare
2021-11-15 15:45:22.342391 | 00b224a5-0947-2b81-da3c-000000000dc4 |      FATAL | Container image prepare | undercloud | error={"changed": false, "error": "None: Max retries exceeded with url: /v2/ (Caused
 by None)", "msg": "Error running container image prepare: None: Max retries exceeded with url: /v2/ (Caused by None)", "params": {}, "success": false}
2021-11-15 15:45:22.343748 | 00b224a5-0947-2b81-da3c-000000000dc4 |     TIMING | tripleo_container_image_prepare : Container image prepare | undercloud | 0:02:19.738944 | 34.95s
```

Possibly a race a condition based on:
https://review.opendev.org/c/openstack/tripleo-heat-templates/+/772893/8#message-becb348c9ef8c4ee0f4e01f819f967d27d05db4f

* Connect to mysql

```
ssh  -F ~/.quickstart/ssh.config.ansible undercloud

MYSQLPASSWD=$(sudo cat /etc/puppet/hieradata/service_configs.json | grep mysql | grep root_password | awk -F": " '{print $2}' | awk -F"\"" '{print $2}')
echo $MYSQLPASSWD
sudo podman exec -ti mysql mysql -u root -p$MYSQLPASSWD
```
