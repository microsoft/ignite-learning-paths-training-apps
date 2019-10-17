# Deployment

Before we start presenting we want to have those things already deployed:

1. The Tailwind Traders web application and databases

## Tailwind Traders web

[![Deploy to Azure](https://azuredeploy.net/deploybutton.svg)](https://deploy.azure.com/?repository=https://github.com/Microsoft/TailwindTraders-Website/tree/master)

- To start deploying this solution, click the `Deploy to Azure` button above.
- Select an appropriate `Subscription`.
- Provide the name of the new resource group that will contain the Tailwind Traders web application.
- Enter the site name and location.
- Set `Deployment Mode` to `standalone`.

> Use a short name (< 20 characters), that name is used to generate resource names. Each resource has different naming restrictions. Stick to lower case characters, numbers, and dashes.

- Enter a `login` name for SQL.
- Enter a strong `password` for SQL. _Do NOT_ use `;` within the password (this is a separator in SQL connection strings).
- After providing all the deployment details, press the `Next` button. You'll see a list of all the Azure resouces that will be created.
- Now press `Deploy`. The actually deployment may take a few minutes to run depending on region.
- After the deplyment completes, navigate to resource group you created to confirm the all the resources were there.

## Website Images

- Open the App Service instance for the web application
- Add a folder named `app_data\productimages` in the `wwwroot` directory.
- Upload the product images there. The product images can be downloaded from [this repository](https://github.com/microsoft/TailwindTraders-Backend/tree/master/Deploy/tailwindtraders-images/product-detail).
- FTP is an easy way to get the images uploaded
  - In the app service instance, go to the `Deployment Center` section.
  - Click on `FTP/Credentials` to get the requirement FTP info
- In the `Configuration` section in the App Service instance, go to `Application Settings`.
- Add a new application setting for `ProductImagesUrl` and set it to `/productimages`
- Remember to press the `Save` button to presist the setting.
- Restart the App Service application

## Create storage account

- Create an Azure Storage accout in the same resource group as the web application.
- Create a Blob container named `productimages`.
- Upload the product images to the container you just created.

## Create Key Vault instance
- Create an Azure Key Vault instance in the same resource group