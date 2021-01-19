# Running Spring Boot + GraalVM native images on Azure Functions

This sample application shows how to:

- Compile a Spring Boot application using GraalVM
- Deploy and run that application on [Azure Functions](https://docs.microsoft.com/azure/azure-functions/?WT.mc_id=java-0000-judubois)

This will use GitHub Actions to do all the heavy work: as we are creating a native image, it needs to be built on a Linux machine with GraalVM installed.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=java-0000-judubois).
- The Azure CLI must be installed. [Install the Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli/?WT.mc_id=java-0000-judubois).
- Terraform must be installed. [Install Terraform](https://www.terraform.io/).

To check if Azure is correctly set up, login using the CLI by running `az login`.

## Fork this repository

All compilation and deployment will be done using GitHub Actions, so you need your own repository for this.
The easiest way is to fork this repository to your own GitHub account, using the `fork` button on the top right-hand corner of this page.

## Create the cloud infrastructure using Terraform

You need to configure the following environment variables:

```bash
export TF_VAR_AZ_LOCATION=westeurope
export TF_VAR_AZ_RESOURCE_GROUP=azure-native-spring-function
export TF_VAR_AZ_FUNCTION_NAME_APP=<your-unique-name>
export TF_VAR_AZ_STORAGE_NAME=<your-unique-name>
```

- `TF_VAR_AZ_LOCATION` : The name of the Azure location to use. Use `az account list-locations` to list available locations. Common values are `eastus`, `westus`, `westeurope`.
- `TF_VAR_AZ_RESOURCE_GROUP` : The resource group in which you will work. It should be unique in your subscription, so you can probably keep the default `azure-native-spring-function`.
- `TF_VAR_AZ_FUNCTION_NAME_APP` : Functions will run into an application, and its name should be unique across Azure. It must contain only alphanumeric characters and dashes and up to 60 characters in length.
- `TF_VAR_AZ_STORAGE_NAME` : Functions binaries and configuration will be stored inside a storage account. Its name should also be unique across Azure. It must be between 3 and 24 characters in length and may contain numbers and lowercase letters only.

In order not to type those values again, you can store them in a `.env` file at the root of this project:

- This `.env` file will be ignored by Git (so it will remain on your local machine and won't be shared).
- You will be able to configure those environment variables by running `source .env`.

Go to the `terraform` directory and run:

- `terraform init` to initialize your Terraform environment
- `terraform apply --auto-approve` to create all the necessary Azure resources

This will create the following Azure resources:

- A resource group that will store all resources (just delete this resource group to remove everything)
- An Azure Functions plan. This is a consumption plan, running on Linux: you will only be billed for your usage, with a generous free tier.
[Here is the full pricing documentation](https://azure.microsoft.com/pricing/details/functions/?WT.mc_id=java-0000-judubois).
- An Azure Functions application, that will use the plan described in the point above.
- An Azure Storage account, which will be used to store your function's data (the binary and the configuration files).

## Configure GitHub Actions to build and deploy the application

The GitHub Actions workflow that we will use is available in [.github/workflows/build-and-deploy.yml](.github/workflows/build-and-deploy.yml).

This GitHub Action will need to use some variables, for this go to your project fork and select "Settings", then "Secrets".

### Configure the AZ_FUNCTION_NAME_APP secret

The `AZ_FUNCTION_NAME_APP` is the name of your function application. It is the same as the `TF_VAR_AZ_FUNCTION_NAME_APP`
environment variable that we configured earlier with Terraform.

Create a new secret called `AZ_FUNCTION_NAME_APP`, paste the value in it, and click "Add secret".

### Configure the AZURE_CREDENTIALS secret

The `AZURE_CREDENTIALS` will allow the GitHub Actions workflow to log in your Azure account, and deploy the application.

This is a JSON payload that we will get by executing the following command:

```bash
RESOURCE_ID=$(az group show --name $TF_VAR_AZ_RESOURCE_GROUP --query id -o tsv)
SPNAME="sp-$(az functionapp list --resource-group $TF_VAR_AZ_RESOURCE_GROUP  --query '[].name' -o tsv)"
az ad sp create-for-rbac --name "${SPNAME}" --role contributor --scopes "$RESOURCE_ID" --sdk-auth
```

Create a new secret called `AZURE_CREDENTIALS`, paste the JSON payload in it, and click "Add secret".

## Deploy and test

Now that everything is set up, your application will be automatically built as a GraalVM native image, and deployed to Azure Functions.

You can change some code, or force a commit to trigger such a build:

```bash
git commit -m "force build" --allow-empty && git push
```

You will be able to monitor that process in the "Actions" tab of your fork of the project.

Once the function is deployed, you can access it though the [Azure Portal](https://portal.azure.com/?WT.mc_id=java-0000-judubois). You will there be able to monitor it and test it.

- Select your resource group
- Select the Azure Functions application you created (its type is "App Service")
- In "Functions", find the function that you have just deployed
- Select "Code + Test"
- You can click on "Test/Run": select a "POST" method, and enter "world" as body. You should have the following output: "Hello, world!"

As you will want to test the performance of this function, still on the "Code + Test" screen, select "Get function URL". Use that function URL to test the performance of your function:

```bash
time curl <YOUR-FUNCTION-URL> -d world -H "Content-Type: text/plain"
```

For monitoring your function, you can also select the "Monitor" tab and create an Azure Applications Insight instance, which will be able to give you detailed metrics (like RAM usage) of your function.

## Tuning the function

The function configuration is in `src/main/function`:

- The name of the directory should be the same as the name of the function. That's how Azure Functions can apply the configuration.
- Documentation for the `host.json` and `function.json` files can be found at [Azure Functions custom handlers](https://docs.microsoft.com/azure/azure-functions/functions-custom-handlers/?WT.mc_id=java-0000-judubois).

The application used here is very simple, and comes from [https://github.com/spring-projects-experimental/spring-graalvm-native/tree/master/spring-graalvm-native-samples/function-netty](https://github.com/spring-projects-experimental/spring-graalvm-native/tree/master/spring-graalvm-native-samples/function-netty).

If you want to work on this function or run it locally, the [https://github.com/spring-projects-experimental/spring-graalvm-native](https://github.com/spring-projects-experimental/spring-graalvm-native) project gives all the necessary documentation.
