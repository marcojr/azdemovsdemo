  BlueHarvest Setup Guide

Setup Guide
===========

Overview:
---------

This demo automates the deployment of a self-hosted agent on Azure DevOps, establishes ARM connections, adds team members to Azure subscriptions, and provisions a blob storage for Terraform backend. It sets up a self-hosted Azure DevOps environment, adds users with appropriate roles to Azure Active Directory (Entra ID), and configures the environment for further deployments. After configuring DevOps, a few services will be deployed for test purposes.

Before Start:
-------------

*   You already have an Azure DevOps organization and project set up.
*   You have a Personal Access Token (PAT) for Azure DevOps with the required permissions.
*   The users to be added must already exist in Azure Active Directory (Entra ID), and only roles will be associated during the setup.
*   You have an active Azure subscription with sufficient capacity to generate resources.
*   A Windows machine is required to run the PowerShell script needed for the setup with Azure CLI installed.

Step 1: Setup
-------------

Initially, it will be necessary to set up Azure DevOps in the already existing organization and project. The setup consists of deploying a self-hosted agent, which eliminates the need to purchase processing credits in DevOps. It will also create a service principal, ARM connections, add users to the subscription that will be part of the project, and a blob responsible for storing the Terraform backend.

### Clone the Repository

First, clone this repository to your local environment:

`git clone <repository_url>`

### Configure Access Control List (ACL)

Navigate to the `setup` directory and edit the `acl.json` file. Add the required team members in the file. Note that these users should already exist in your Entra ID.

### Run the Setup Script

After configuring the ACL, navigate to the setup directory and run the following PowerShell script to initiate the setup:

`./initEnv.ps1 -subscriptionId '<your_subscription_id>' -subscriptionName '<your_subscription_name>' -organizationName '<your_ado_organization>' -projectName 'blueharvest' -poolName '<agent_pool_name where the self-host agent will belong>'`

During the script execution, you'll be prompted to enter the following:

*   **Azure DevOps Personal Access Token (PAT):** Enter the PAT for your Azure DevOps account.

Before entering the PAT, note the console output, such as:

    spClientId: xxxxx
    subscriptionId: xxxx
    subscriptionName: xxxxx
    spTenantId: xxxxxx
    spClientSecret: xxxxx
    organizationName: xxxx
    projectName: xxx
    poolName: xxxx

Copy the **spClientSecret** value and store it temporarily in a safe place, like a text editor.

Then, provide the PAT in the prompt.

In the next prompt: **Azure RM Service Principal Key**—provide the spClientSecret that was generated during the setup process.

### Finalizing Setup

If everything completes successfully, you will see confirmation that the self-hosted agent is deployed, running, and associated with your specified DevOps pool. You should also see the ARM connections and the roles associated with the users in your Entra ID.

Step 2: Environment Setup (dev, sit, prod)
------------------------------------------

### Second Stage: Provisioning an Environment

This demo is designed to work with three environments: dev, sit, and prod.

To provision the Azure resources for each environment, you need to configure and run the pipeline in ADO. You will also need to create a repository in ADO to host the source files.

### Create a Repository in Azure DevOps (ADO)

Create a new repository in ADO for your project. Be sure to delete the file `setup/command-to_run.sh` as it contains sensitive information and may cause your push to be rejected by ADO due to security rules. Don’t worry, this is an automatically generated file by `initDevOps.ps1`.

### Adjust the Pipeline Configuration

Modify the `project/pipelines/azure-pipeline.yml` file. Replace the placeholder pool name 'teste' with the actual pool name that you used in the setup script.

### Push Files to the ADO Repository

Once the pipeline is configured, push all files from the local repository to your ADO repository, making sure you are using the **master** branch.

### Create and Run the Pipeline

In Azure DevOps, navigate to the Pipelines section:

1.  Click the "Create Pipeline" button.
2.  Select Azure Repos Git as the repository source.
3.  Select the repository you created.
4.  Choose "Existing Azure Pipelines YAML file" when asked how you want to configure the pipeline.
5.  Select the correct YAML file from the repository.
6.  Save the pipeline configuration without running it.

### Running the Pipeline

Once the pipeline is saved:

1.  Go back to the pipeline dashboard in ADO.
2.  Select the pipeline and click on "Run Pipeline."
3.  A dialog will appear prompting you to choose the environment you want to deploy (dev, sit, or prod).
4.  After choosing the environment, click "Run."

If the message "This pipeline needs permission to access a resource before this run can continue" appears, click on "View" and grant the required permissions. The resource provisioning will start, and you can monitor the process as it runs.

Description of the Solution:
----------------------------

*   **Azure Container Registry (ACR):** A dedicated container registry is deployed for storing container images, which are crucial for AKS deployments. The ACR allows you to manage and secure images used in your Kubernetes environment.
*   **Azure Kubernetes Service (AKS):** A fully managed Kubernetes cluster is deployed to host containerized applications. AKS integrates with ACR, allowing it to pull images directly from the registry. It is also integrated with Azure Monitor for logging and monitoring purposes.
*   **Monitoring (Log Analytics):** The solution includes a Log Analytics Workspace that captures logs and metrics for both the AKS cluster and ACR. This ensures proper observability, diagnostics, and monitoring for both services.
*   **Azure Virtual Network (VNet):** A virtual network (VNet) is created to isolate the AKS cluster and other resources, ensuring network-level security and performance. Subnets are created within the VNet to define network boundaries and resource segmentation.
*   **Azure Subnet (snet):** A subnet is created within the VNet to host the AKS cluster and potentially other resources, allowing for proper IP address management and security boundaries.
*   **Log Analytics Integration:** Both ACR and AKS services are integrated with Azure Log Analytics to capture detailed logs and diagnostics data, providing real-time monitoring and alerting capabilities. This integration ensures that all the services in the environment are monitored effectively.

Key Benefits:
-------------

*   **Scalability:** AKS offers auto-scaling capabilities for workloads, allowing dynamic resource management based on traffic and application needs.
*   **Security:** The solution leverages a Virtual Network (VNet) to securely isolate the environment, with Azure's built-in security features ensuring proper access controls.
*   **Monitoring and Diagnostics:** Log Analytics captures and stores diagnostic data from the AKS and ACR services, enabling detailed monitoring, alerting, and root cause analysis for operational issues.
*   **Containerized Workflows:** By integrating ACR and AKS, the solution supports modern containerized application workflows, enabling DevOps practices like CI/CD (Continuous Integration/Continuous Deployment).
    
    High Level Design:
    ------------------
    
    This is a ToDo task - Will be provided later, I am exausted
    
    for now, this is the best I can do for the moment...LOL
    
        
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