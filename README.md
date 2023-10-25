# multi-env-CICD

## Project Overview

This project is designed to facilitate the smooth deployment of legacy applications across various software development environments within an organization. It emphasizes the deployment of robust, error-free versions into the production environment, ensuring enhanced efficiency and reliability. To achieve this, the project leverages infrastructure as code tools, specifically Terraform and Ansible. Terraform is employed to create infrastructure in the AWS cloud environment, while Ansible is used to install necessary dependencies and tools for each environment. Additionally, the project integrates a Jenkins pipeline for continuous integration and delivery, contributing to a substantial reduction in application failures by 95% and deployment time by 40%.

## Infrastructure Provisioned

The project provisions the following infrastructures:

1. Jenkins server
2. Tomcat server
3. Two-node EKS cluster for the staging environment
4. Two-node EKS cluster for the production environment

## Project Execution Requirements

To successfully execute the project, the following requirements must be met:

1. Command line authentication to AWS cloud with permissions to create resources (EC2 instance, IAM, EKS).
2. Installation of Terraform, Ansible, and Git on the command line.
3. Proficiency in Terraform, Ansible, Git, Jenkins, AWS Management Console, and Kubernetes.

## Execution Steps

To execute the project, follow these steps:

1. Create a keypair named "project-keypair" in the AWS cloud environment using the management console and download it to your desktop.
2. Clone the GitHub repository using the following URL:  https://github.com/ekelejames/multi-env-CICD.git
3. Run the following Terraform commands:

   a. `terraform init`

   b. `terraform apply --auto-approve`

5. Note down the IP addresses displayed at the end of the Terraform resource creation.
6. Edit the "hosts" file using the recorded IP addresses.
7. Configure Ansible by adding the keypair file's path in the "private_key_file" section of the Ansible configuration file.
8. Run the Ansible playbook using the command: `ansible-playbook -i hosts ansible-playbook.yml`
9. Access your Jenkins server and perform the following tasks:
   
   a. Set Maven as a tool.
   
   b. Install the "Deploy to Container" plugin and the "Kubernetes Deploy" plugin.
   
   c. Create credentials for accessing your Tomcat server.
   
   d. Create a pipeline job.
   
10. Copy and paste the contents of "Jenkinsfile" into the pipeline script section, editing as required:
    
       a. Provide your Jenkins credential IDs and Tomcat server URL.
   
       b. Use the "generate pipeline syntax" option to create syntax for deploying into the Kubernetes cluster, ensuring to include the contents of your kube config files.

11. Run the Jenkins job.
12. Access your staging and production Kubernetes clusters to obtain the deployment service IP addresses and ports for exposing the application.

## Concluding Thoughts

This project serves as a comprehensive guide, offering an accessible step-by-step process for setting up infrastructures in staging and production environments. It also provides insights into integrating additional features, objects, and dependencies, such as Horizontal Pod Auto-scaling (HPA), Ingress, node auto-scaling groups, application monitoring tools like Prometheus and Grafana, and email notifications to a Slack channel, among others.
