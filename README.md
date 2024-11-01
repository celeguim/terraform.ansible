# Terraform & Ansible Provider Example

An example of Terraform and Ansible configuration using a dynamic Terraform inventory.

## Terraform

For simplicity, Terraform will creates 2 EC2 instances on **AWS/us-east-1**.

My own private key (id_rsa.pub) will be added into the instances and my private key (id_rsa) will be used for SSH authentication.

#### Requirements

- AWS account
- Local SSH keys

#### Initialize

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

#### Create Virtual Environment

```sh
# Create the environment.
python -m venv .venv
# Activate the virtual environment.
source .venv/bin/activate
pip install ansible
```

#### Install Requirements

```sh
cd ansible
ansible-galaxy install -r requirements.yml
```

Installed collections will be stored in an `ansible_collections` directory, by default ~/.ansible/collections

#### Inventory

The inventory file is `terraform.yaml`

This file uses the [Terraform provider plugin](https://github.com/ansible-collections/cloud.terraform/blob/main/docs/cloud.terraform.terraform_provider_inventory.rst), defines the Terraform project path and the `terraform` binary path:

```yml
plugin: cloud.terraform.terraform_provider
project_path: ../terraform
# Binary name or full path to the binary.
binary_path: terraform
```

The inventory file is set in the `ansible.cfg` file.

#### Usage

List Terraform inventory with all the variables:

```sh
ansible-inventory --graph --vars
@all:
  |--@ungrouped:
  |--@web:
  |  |--@aws:
  |  |  |--web1
  |  |  |  |--{ansible_host = 1.2.3.4}
  |  |  |  |--{ansible_ssh_private_key_file = ../.ssh/demo_key}
  |  |  |  |--{ansible_user = admin}
  |  |  |  |--{fqdn = web1.example.com}
  |  |  |  |--{hostname = web1}
  |  |  |  |--{list_var = ["one","two","three"]}
  |  |  |  |--{map_var = {"country":"US","region":"us-east-1"}}
  |  |--@hetzner:
  |  |  |--web2
  |  |  |  |--{ansible_host = 5.6.7.8}
  |  |  |  |--{ansible_ssh_private_key_file = ../.ssh/demo_key}
  |  |  |  |--{ansible_user = root}
  |  |  |  |--{fqdn = web2.example.com}
  |  |  |  |--{hostname = web2}
  |  |--{ansible_ssh_private_key_file = ../.ssh/demo_key}
```

Run a raw command on the hosts created by Terraform:

```sh
ansible all -m raw -a uptime
```

Output:

```sh
$ ansible all -m raw -a uptime
web2 | CHANGED | rc=0 >>
 17:25:14 up 15 min,  1 user,  load average: 0.00, 0.00, 0.00
Shared connection to 5.6.7.8 closed.

web1 | CHANGED | rc=0 >>
 17:25:14 up 15 min,  1 user,  load average: 0.00, 0.00, 0.00
Shared connection to 1.2.3.4 closed.
```
