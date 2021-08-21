
# comma delimited string of providers to register, for example: $providersToRegister = 'Microsoft.ServiceBus,Microsoft.AAD'

$providersToRegister = 'Microsoft.ServiceBus'

$providers = $providersToRegister.Split(",") 
ForEach ($provider in $providers)
{
    $registered = Get-AzResourceProvider -ProviderNamespace $provider -ErrorAction SilentlyContinue

    # if the provider was not found, likely due to a typo, then skip to next
    if($null -eq $registered.RegistrationState)
    {
        Write-Error "The provider $($provider) was not found."
        continue
    }

    # if provider is already registered then skip to next
    if($registered.RegistrationState -eq 'Registered')
    {
        Write-Output "The provider $($provider) is already register."
        continue
    }

    Write-Output "Registering the provider $($provider)."

    Register-AzResourceProvider -ProviderNamespace $provider

    Write-Output "Registered the provider $($provider)."

}