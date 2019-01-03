# Index
1. [Homewok N3](#homework-n3)
2. [Homewok N4](#homework-n4)
3. [Homewok N5](#homework-n5)
4. [Homewok N6](#homework-n6)
5. [Homewok N7](#homework-n7)
6. [Homewok N8](#homework-n8)
7. [Homewok N8](#homework-n9)

## Homework N3

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

We developed basic parametrized Terraform configuration for Reddit application deployment from Packer base image. Examples of input variables can be found in `terraform/terraform.tfvars.example`.

To apply the configuration to GCP use and deplot the Reddit application:
```
cd terratorm
mv terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
teffaform apply
```
Running application can we found at: `http://app_external_ip:9292` The `app_external_ip` is the output variable of Terraform configuration.

#### Extra task1

Several public ssh keys were added to the project level. **NOTE**: *In case of Terraform usage you can't mix manually added and Terraform applied ssh-keys. Terraform will delete any of manually added keys.*

#### Extra task2

HTTP Load ballancer was added to Terraform configuration. Reddit application can be deployed in any number of instances with `vm_instances_number` variable. Running application can we found at: `http://lb_external_ip` The `lb_external_ip` is the IP-address of load balance, it is output variable of Terraform configuration.

## Homework N7

This homework was devoted to decomposition of complex terraform configurations and code reuse.

* We learned how to import existing and running platfrom componets into terraform configuration with `terraform init` command.
* Examineted explicit and implicit resorces relationship in terraform configuration.
* Tried a simple way of decomposition of terraform configuration when one large file is splited into several smaller according to the logical entities.
* The we learned the advanced way of decompostion - terraform modules. They make terrafrom configuration easy to read and allow code reusage.
* And at the end we tested the official HashiCorp Terraform Register which includes code of terraform modules writen by other people.

#### Terraform module app
Parameter `fw_app_port` added which specifies the tcp port number wich will be opened at VCP firewall for the application access

#### Terraform module vcp
Parameter `source_rangers` added to specify the IP addresses which are allowed to connect to ssh port of any VM instance.

#### Output terraform variables
* `app_external_ip` - shows extarnal nat IP-address of app instance
* `db_external_ip` - shows extarnal nat IP-address of db instance
* `vpc_source_ip_ranges` - shows allowed IP-addresses for ssh connection to app and db instances.

#### New Packer images
`packer/app.json` and `packer/db.json` - two new templates which are used now instead of common ubuntu16.json

#### Current terraform configuratoins
* `terraform/stage/main.tf` - parametrized configuration with own variables for stage deployment
* `terraform/prod/main.tf` - parametrized configuration with own variables for prod deployment
* `terraform/storage-bucket.tf` - example of usage of `terraform-google-storage-bucket` HashiCorp module

#### Extra task 1
We moved stage and prod terrafrom backend from local disk to GCS buket. It allows us to store terraform state-file safely and makes available team-work with the same terraform configuration.
Configuration is described in `backend.tf` files. [official doc](https://www.terraform.io/docs/backends/types/gcs.html)

## Homework N8

First steps with Ansible automation tool.

* We installed Ansible tool with all necessary dependences.
* Configured Ansible to allow it to interract with our VM instances at GCP.
* We learned about different Ansible inventory formats: ini, yaml and dynamic.
* We tried to use Ansible modules: ping, command, shell, systemd, service, git.
* Finaly we wrote very basic Ansible playbook.

#### Usage of playbooks
>ansible-playbook ansible/clone.yml

The Ansible will check if required changes are already made or not. If Ansible makes any changes on remote host then result message will include `ok=2 changed=1`, otherwise the output will be just `ok=2`.

#### Extra task
>ansible all -i get-dynamic-inventory.sh -m ping

The following command will apply the dynamic configuration. Executable script `git-dynamic-inventory.sh` with `--list` argument will provide the JSON-structure with VM instances of Ansible tool.
[official doc](https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html)

## Homework N9

A continuation of work with Ansible automation tool. We implemented 3 version of the same task.

* Single playbook with single play `ansible/reddit_app.yml`
* Single playbook with 3 plays `ansible/reddit_app2.yml`
* 3 playbooks united with one main playbook `ansible/site.yml`
* In addition we updated packer provisioners with 2 playbooks `ansible/packer_app.yml` and `ansible/packer_db.yml`

#### To deploy Reddit-app in updated envitonment do the following.
First build new images:

>packer build -var-file=packer/variables.json packer/db.json
>packer build -var-file=packer/variables.json packer/app.json

Then deploy stage environment in terrafrom:

>cd terraform/stage
>terraform destroy
>terraform apply

Update app and db servers IPs at `ansible/inventory` and at last apply ansible playbook:

>packer build -var-file=packer/variables.json packer/db.json
>packer build -var-file=packer/variables.json packer/app.json
