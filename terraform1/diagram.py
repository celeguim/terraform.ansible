from diagrams import Diagram, Cluster

from diagrams.aws.network import VPC
from diagrams.aws.network import PublicSubnet
from diagrams.aws.network import PrivateSubnet
from diagrams.aws.enduser import Workspaces

from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
from diagrams.aws.network import Route53
from diagrams.onprem.database import PostgreSQL  # Would typically use RDS from aws.database
from diagrams.onprem.inmemory import Redis  # Would typically use ElastiCache from aws.database

with Diagram("Terraform & Ansible Diagram", direction='LR') as diag:

    vpc = VPC("VPC1")
    with Cluster("My-Custom-VPC"):
        vpc_group = [PublicSubnet("vpc1-public-0"),
                     PublicSubnet("vpc1-public-1"),]
    

    end_user = Workspaces("End User")
    end_user >> vpc_group
    
    # dns = Route53("dns")
    # load_balancer = ELB("Load Balancer")
    # database = PostgreSQL("User Database")
    # cache = Redis("Cache")
    
    # with Cluster("Webserver Cluster"):
    #     svc_group = [EC2("Webserver 1"),
    #                  EC2("Webserver 2"),
    #                  EC2("Webserver 3")]
    # dns >> load_balancer >> svc_group
    # svc_group >> cache
    # svc_group >> database

diag  # This will illustrate the diagram if you are using a Google Colab or Jypiter notebook.
