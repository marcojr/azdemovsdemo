param (
    [string]$env,                # Parameter for environment (dev, sit, prod)
    [string]$subscriptionId      # Parameter for Azure subscription ID
)

# Check if the required parameters were provided
if (-not $env -or -not $subscriptionId) {
    Write-Host "The 'env' and 'subscriptionId' parameters are required." -ForegroundColor Red
    exit 1
}

# Log in to Azure
Write-Host "Logging into Azure..." -ForegroundColor Cyan
az login

# Set the correct subscription
Write-Host "Setting the subscription..." -ForegroundColor Cyan
az account set --subscription $subscriptionId

# Define the Resource Group name based on the environment parameter
$resourceGroupName = "rg-blueharvest-$env"

# Confirmation prompt before deleting the Resource Group
$confirm = Read-Host "Are you sure you want to delete the Resource Group $resourceGroupName and all its resources? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Operation canceled." -ForegroundColor Yellow
    exit 0
}

# Delete the Resource Group and all its associated resources
Write-Host "Deleting the Resource Group $resourceGroupName and all its resources..." -ForegroundColor Cyan
az group delete --name $resourceGroupName --subscription $subscriptionId --yes --no-wait

# Final message to indicate the deletion process has started
Write-Host "Deletion initiated for Resource Group $resourceGroupName. All resources within it will be deleted." -ForegroundColor Green
