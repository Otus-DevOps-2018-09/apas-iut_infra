## Homewok N3

#### Log in via command line

To log in to `someinternalhost` from working device via command line use the following command:
> ssh -i ~/.ssh/appuser -A appuser@35.210.86.252 -t ssh appuser@10.164.0.2

#### Log in via alias

To log in to `someinternalhost` from working device via alias
> ssh someinternalhost

add to the file `~/.ssh/config` the following configuration:
```
Host someinternalhost
	HostName 10.164.0.2
	User appuser
	IdentityFile ~/.ssh/appuser.pub
	ProxyCommand ssh -q -W %h:%p appuser@35.210.86.252
```

#### Data for bot connection
bastion_IP = 35.210.86.252
someinternalhost_IP = 10.164.0.2

