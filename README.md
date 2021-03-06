## Exercise 2: Infrastructure

Duration: You should spend around 1 hour

### Scenario

In this exercise, Cognigy has two environments, dev and prod, both running on AWS. On each environment, we want to deploy 
a Kubernetes cluster. Thus, the SRE team prepares Terraform code to manage the infrastructure as code. You find it in this 
repository in two directories: `dev-environment` and `prod-environment`.

Before answering the questions, please note that:

- You don't need to be familiar with Terraform or AWS to do the exercise. We want to see your knowledge about 
infrastructure as code, networking and security and more.
- You don't need to run this code. We are even not sure if the code is functional :)
- There are no wrong or right answers.  We want to discuss your solution with you in the interview.

### Questions

1. Please list all the possible improvements to this Terraform code. It can be but NOT limited to code structure, code 
management, Terraform  syntax, AWS usage, security, Kubernetes.

2. Design monitoring, logging and alerting architecture for these environments. You're not limited in your choice of 
solutions or tools but open-source tools are preferred. You don't need to write any code here.

### Extra Credit Question

1. Imagine Cognigy grows fast, and you need to scale such environments to dozens of installations. What would be
your suggestion to improve previous solutions to make deployment, monitoring and logging architectures scalable?


## Solution

### Change directory structure and to use workspaces instead of different directories for dev and prod
Use the default workspace for `dev` and create a new workspace for `prod` such that code management can be done in a single directory.
```shell
# Create (and switch to) new workspace for production
terraform workspace new prod
```

### Add provider requirements
Declare requirement of `aws` provider, so that Terraform can install it.

### Use the `for_each` Meta-Argument to manage several similar items
Use the `for_each` meta-argument in resource blocks iteratively create subnets and their respective route associations.
To facilitate this, transform the `subnet_availability_zones` input variable into a local variable.
Also, adjust the CIDR ranges for the subnets to avoid overlap (all subnets had the same CIDR range: `172.0.0.0/20`) and adjust the VPC CIDR range to provide more IP addresses.

The `for_each` meta-argument is also used to condense management of EFS mount targets for each subnet.

### Prevent modification of the default security group
Prevent modification of the default security group, instead create a new security group by changing `aws_default_security_group` resource to `aws_security_group`.

### Restrict inbound traffic to TCP protocol
Prevent inbound traffic from other protocols (except SSH) as the cluster components only needs to communicate via SSH. This would provide better security.

### Extract kops arguments into terraform variables
Extract kops arguments: master node size, master node count, node size, and node count into terraform variables such that they can be dynamically changed at runtime.
In terms of general Kubernetes architecture, a production cluster should have at least 3 master nodes (only one specified in config) in different availability zones to ensure high availability (HA).
Also, worker nodes should definitely be more than one (only one specified).

### Usage of kops
Firstly, the generated `kops` command is never run automatically by terraform, this means the Kubernetes cluster is never fully provisioned.

A suggestion would be to pull out the entire provisioning process into an ansible playbook. 
Such that the initial provisioning of the resources required by `kops` is handled in ansible, then `kops create` is run with the `--target=terraform` flag such that the required terraform files to create the cluster are generated, then `terraform apply` is run to actually create the cluster, and finally `kops validate` to ensure that the cluster is working as expected.
On cluster edit/update, only the generated terraform files need be updated (or `kops update` nneds to be run), followed by `terraform apply` to update the actual state to the desired state. A sample ansible playbook would look like:

```yaml
-   name: Kubernetes Cluster Creation
    hosts: localhost
    connection: local
    vars:
        clusterName: custer-name-here
        awsZones: "comma,listed,zones"
        outDir: ./kops-terraform

    tasks:
        -   name: setup required AWS resources for kOps
            # Setup IAM user, configure DNS, & setup S3 backend

        -   name: generate terraform files
            ansible.builtin.shell:
                cmd: kops create cluster --name={{clusterName}} ---cloud=aws --zones={{awsZones}} --out=.{{outDir}} --target=terraform

        -   name: apply terraform config
            ansible.builtin.shell:
                chdir: {{outDir}}
                cmd: terraform apply

        -   name: validate cluster creation
            ansible.builtin.shell:
                cmd: kops validate cluster --wait 15m
```

### Configure S3 backend
Add required configuration to S3 backend definition.

### Add ACL to S3 bucket
Add ACL to S3 bucket to prevent unauthorized access.

### Monitoring, Logging, and Alerting Architecture
Monitoring and Alerting: Prometheus + AlertManager + Grafana
![monitoring-architecture](./img/monitoring-architecture.jpg)

Logging: Fluentd + Elasticsearch + Kibana
![logging-architecture](./img/logging-architecture.jpg)

### Extra Credit Question
For scalability, create ansible playbooks that initialize a cluster which can be reused as necessary.
