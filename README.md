# Repo for DCSG2003 Robuste og skalerbare tjenester





**OpenStack**

```bash
# List parameters
openstack flavor list
openstack image list
#
# Create server
openstack server create --flavor FLAVOR_ID --image IMAGE_ID --key-name KEY_NAME \
  --user-data USER_DATA_FILE --security-group SEC_GROUP_NAME --property KEY=VALUE \
  INSTANCE_NAME
  
# Check if the instance is online
openstack server list # / nova list

```



**Shell Script**

```bash
#! /bin/bash
function <Name> {
	
}
<Name>

# .sh
# chmod +X
# Alias: 
# Append <alias name='Command'> to ~/.bashrc
# Source ~/.bashrc
```



**Git; remove files**

*From both Git repo and filesystem*

```bash
git rm file.txt
git commit -m "removed file.."
git push
```

*From git repo only*

```bash
git rm --cached file.txt
git commit -m "removed file.."
git push
```

