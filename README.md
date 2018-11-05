# Index
1. [Homewok N3](#homework-n3)
2. [Homewok N4](#homework-n4)
3. [Homewok N5](#homework-n5)
4. [Homewok N6](#homework-n6)


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

## Homework N4

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

## Homework N5

This homework was devoted to the study of the Packer utility as a tool for creating images of virtual machines.

We made two teplates for fast images creation: `packer/ubuntu16.json` and `packer/immutable.json`. First template is used to implement "Fry" apporoach while second demonstated the "Bake" method.
To use them first rename `variables.json.exapmle` to `variables.json` and make the appropriate variables change.

Then run the Packer tool like:

>packer build -var-file=variables.json ubuntu16.json

or

>packer build -var-file=variables.json immutable.json

File `packer/config-scripts/create-reddit-vm.sh` includes the example of usage of previously prepared Packer "bake" image to create virtual machine running Reddit application.

## Homework N6

We developed the basic parametrized Terraform configuration for reddit application deployment from Packer base image. Examples of input variables can be found in `terraform/terraform.tfvars.example`.

To apply the configuration to GCP use:
```
cd terratorm
terraform init
teffaform apply
```

Added several public ssh keys to the project level. **NOTE**: *In case of Terraform usage you can't mix manually added and Terraform applied ssh-keys. Terraform will delete any of manually added keys.*
