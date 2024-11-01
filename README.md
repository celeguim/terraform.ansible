# Terraform & Ansible Provider Example

An example of Terraform and Ansible configuration using a dynamic Terraform inventory.

## Terraform

For simplicity, Terraform will creates 2 EC2 instances on **AWS/us-east-1**.

My own private key (id_rsa.pub) will be added into the instances and my private key (id_rsa) will be used for SSH authentication.

#### Requirements

- AWS account
- Local SSH keys

#### Initialize

This will install the required providers defined in version.tf

```sh
cd terraform
terraform init
```

#### Create Resources

```sh
terraform apply
```

#### Destroy

```sh
terraform destroy
```

## Ansible

#### Install Requirements

```sh
cd ansible
ansible-galaxy install -r requirements.yaml
```

Installed collections will be stored in an `ansible_collections` directory, by default ~/.ansible/collections

#### Inventory

The inventory file is `terraform.yaml`

This file uses the [Terraform provider plugin](https://github.com/ansible-collections/cloud.terraform/blob/main/docs/cloud.terraform.terraform_provider_inventory.rst), defines the Terraform project path and the `terraform` binary path:

```yml
plugin: cloud.terraform.terraform_provider
project_path: ../terraform
binary_path: terraform
```

The inventory file is set in the `ansible.cfg` file.

#### Usage

List Terraform inventory with all the variables:

```sh
ansible-inventory --graph --vars

@all:
  |--@ungrouped:
  |--@aws_web:
  |  |--web1
  |  |  |--{ansible_host = 44.222.228.94}
  |  |  |--{ansible_user = ubuntu}
  |  |  |--{fqdn = web1.example.com}
  |  |  |--{hostname = web1}
  |  |  |--{map_var = {"provider":"AWS","region":"us-east-1"}}
  |  |  |--{packages = ["openjdk-11-jre","tomcat10","tomcat10-admin"]}
  |  |--web2
  |  |  |--{ansible_host = 44.222.209.137}
  |  |  |--{ansible_user = ec2-user}
  |  |  |--{fqdn = web2.example.com}
  |  |  |--{hostname = web2}
  |  |  |--{map_var = {"provider":"AWS","region":"us-east-1"}}
  |  |  |--{packages = ["nginx","nginx-plus-module-njs"]}
```

To check Ansible, run a shell module on the hosts created by Terraform:

```sh
ansible all -m ansible.builtin.shell -a 'echo Hostname: $(hostname)'

web2 | CHANGED | rc=0 >>
Hostname: ip-172-31-30-203.ec2.internal

web1 | CHANGED | rc=0 >>
Hostname: ip-172-31-24-22
```

### Install Playbook

Install the packages defined in the packages variable (aws.tf)

```sh
ansible-playbook playbook1.yaml -vvv

PLAY RECAP **************************************************************************************************************************
web1                       : ok=2    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
web2                       : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
```