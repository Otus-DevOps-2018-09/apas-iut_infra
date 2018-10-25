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

## Homewok N4

#### Data for bot connection.
testapp_IP = 35.195.75.124
testapp_port = 9292

#### VM instance auto-deployment script. Option with local startup script file.
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone=europe-west1-b \
  --metadata-from-file startup-script=startup_script.sh
```

#### VM instance auto-deployment script. Option with script file located at GCP bucket.
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone=europe-west1-b \
  --metadata=startup-script-url='gs://otus-apas/startup_script.sh'
```

#### Firewall rule auto-deployment script.
```
gcloud compute firewall-rules create default-puma-server \
  --target-tags=puma-server \
  --source-ranges="0.0.0.0/0" \
  --allow tcp:9292 \
  --description="Allow from any to Puma-server"
```
