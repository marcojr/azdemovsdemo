# BlueHarvest Setup Guide

## Overview

This project automates the deployment of a self-hosted agent on Azure DevOps, establishes ARM connections, assigns users to the subscription, and provisions resources necessary for a fully functional Azure environment. The setup script also manages Terraform backend storage for state files.

----------

## Prerequisites

1.  **Azure Subscription**: Ensure an active Azure subscription with the required permissions to create and manage resources.
2.  **Azure DevOps Organization**: Make sure you have an existing Azure DevOps (ADO) organization and project.
3.  **Azure DevOps Personal Access Token (PAT)**: You will need a PAT with sufficient permissions for the required operations.
4.  **Windows Machine**: The setup requires running the PowerShell script from a Windows environment.
5.  **Azure Active Directory Users**: Users to be added to the ACL must already exist and have appropriate roles in Azure AD.

----------

## First Step: Setup

1.  **Clone the Repository**:
    
    ```
    git clone <repository_url>
    ```
    
2.  **Configure Access Control List (ACL)**:
    -   Navigate to the  `setup`  directory.
    -   Edit the  `acl.json`  file to add the users. These users must already exist in the Azure AD.
3.  **Run the Setup Script**:
    
    ```
    ./initEnv.ps1 -subscriptionId '<your_subscription_id>' -subscriptionName '<your_subscription_name>' -organizationName '<your_ado_organization>' -projectName 'blueharvest' -poolName '<agent_pool_name>'
    ```
    

### Respond to Prompts

-   Enter your Azure DevOps PAT when prompted.
-   Enter the  `spClientSecret`  from the console output when prompted.

You should see confirmation of a self-hosted agent installation and other configuration details when successful.

----------

## Second Step: Provision Environment

This demo supports deploying resources to the following environments:  `dev`,  `sit`, and  `prod`.

### Create a New Repository in Azure DevOps

-   Push all files from the cloned repository (excluding  `setup/command-to_run.sh`  due to sensitive information).
-   Modify the  `azure-pipeline.yml`  file:
    -   Replace the  `pool: teste`  line with the appropriate pool name from your setup.

### Create a Pipeline

1.  Navigate to Pipelines > Create Pipeline.
2.  Select "Azure Repos Git" and your repository.
3.  Choose "Existing Azure Pipelines YAML file" and select the  `azure-pipeline.yml`.
4.  Save the pipeline, but don’t run it yet.

### Run the Pipeline

-   On the pipeline page, select “Run Pipeline.”
-   Choose the environment to deploy (`dev`,  `sit`,  `prod`).
-   If prompted with  _This pipeline needs permission to access a resource_, approve the permission request.

----------

## Infrastructure Overview

### High-Level Design (HLD)

## ToDo: A graphical and improved HLD here - sorry I am exausted for today
<pre>
+---------------------------------------+
| Azure Resource Group (rg-blueharvest) |
+---------------------------------------+
              |
+--------------------------------+   
| Azure Container Registry (ACR) |
+--------------------------------+   
              |
+---------------------+     +--------------------+
| Azure Kubernetes    |<--->| Log Analytics      |
| Service (AKS)       |     | Workspace (Logs)   |
+---------------------+     +--------------------+
              |
+-------------------------+
| Azure Virtual Network   |
| (VNet) + Subnet (snet)  |
+-------------------------+
</pre>

## Description of the Solution

-   **Azure Resource Group (rg-blueharvest)**: Centralized management of all resources, grouped logically under a single resource group.
-   **Azure Container Registry (ACR)**: A dedicated registry for container images used by AKS.
-   **Azure Kubernetes Service (AKS)**: Managed Kubernetes cluster for hosting containerized applications. Integrated with ACR for pulling container images and Log Analytics for monitoring.
-   **Azure Virtual Network (VNet)**: Network isolation for AKS and related resources, with subnets providing IP management and security boundaries.
-   **Log Analytics Workspace**: Monitors AKS and ACR, capturing logs and metrics for diagnostic and monitoring purposes.

### Key Benefits

-   **Scalability**: AKS auto-scaling manages workloads dynamically.
-   **Security**: VNet isolation and Azure’s security controls ensure resource protection.
-   **Monitoring & Diagnostics**: Integrated monitoring with Log Analytics ensures visibility into system performance and issues.
-   **Containerized Workflows**: Support for modern DevOps practices with containerization and CI/CD workflows.
