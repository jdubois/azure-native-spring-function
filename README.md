# Running Spring Boot + GraalVM native images on Azure Functions

This sample application shows how to:

- Compile a Spring Boot application using GraalVM
- Deploy and run that application on [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/?WT.mc_id=github-social-judubois)

## Configure environment variables

You need to configure the following environment variables:

```bash
AZ_LOCATION=westeurope
AZ_RESOURCE_GROUP=azure-native-spring-function
AZ_FUNCTION_NAME_APP=azure-native-spring-function
AZ_STORAGE_NAME=nativespringfunction # must be between 3 and 24 characters in length and may contain numbers and lowercase letters only.
```


## Configure Azure Credentials

```bash
az ad sp create-for-rbac --name http://azure-native-spring-function --role contributor --scopes /subscriptions/10494bac-4dc9-4f66-9563-996f688d9c6c/resourceGroups/azure-native-spring-function --sdk-auth
```
