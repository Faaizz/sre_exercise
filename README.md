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
