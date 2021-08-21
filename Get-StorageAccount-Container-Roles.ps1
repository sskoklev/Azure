<#
    Get the roles assigned to all containers within specified subscription/resource group/storage account for spn prefix
    NOTE:
        - This must be executed within CloudShell by someone who has required permissions
        - Update input parameters
        - Copy this script directly into CloudShell and execute
#>

## Input Parameters
$subscriptionName="<ENTER SUBSCRIPTION NAME>"
$resourceGroupName="<ENER RESOURCE GROUP NAME>"
$storageAccName="<ENTER STORAGE ACCOUNT NAME>"
$spnPrefix="<ENTER SPN NAME PREFIX>"

## Connect to Azure Account
$subscription = Get-AzSubscription | Where-Object{$_.Name -eq $subscriptionName}

Set-AzContext -SubscriptionId $subscription.Id

## Function to get all the containers
Function GetAllStorageContainerRoles
{
    Write-Host -ForegroundColor Green "Retrieving storage container.."
    ## Get the storage account from which container has to be retrieved
    $storageAcc=Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccName
    ## Get the storage account context
    $ctx=$storageAcc.Context
    ## List all the containers
    $containers=Get-AzStorageContainer  -Context $ctx
    foreach($container in $containers)
    {
        write-host -ForegroundColor Yellow $container.Name

        $roles=Get-AzRoleAssignment -Scope "/subscriptions/$($subscription.Id)/resourcegroups/$($resourceGroupName)/providers/Microsoft.Storage/storageAccounts/$($storageAccName)/blobServices/default/containers/$($container.Name)" | Where-Object {$_.DisplayName -like $($spnPrefix)} | Select-Object DisplayName, RoleDefinitionName

        write-host -ForegroundColor Red $roles
    }
}

GetAllStorageContainerRoles
