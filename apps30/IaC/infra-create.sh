#!/bin/bash

set -e

# Credentials
azureResourceGroup=igniteapps30
adminUser=twtadmin
adminPassword=twtapps30pD
subName="Ignite The Tour"
location=eastus
# DB Name
cosmosdbname=apps30twtnosqlge
sqldbname=apps30twtsql
acrName=igniteapps30acr

# Create resource group
az group create --subscription "$subName" --name $azureResourceGroup --location $location

# Create VNet
az network vnet create --name igniteapps30vnet --subscription  "$subName" --resource-group $azureResourceGroup   --subnet-name default

# Create Azure Cosmos DB
az cosmosdb create --name $cosmosdbname --resource-group $azureResourceGroup --kind MongoDB --subscription "$subName" 

cosmosConnectionString=$(az cosmosdb list-connection-strings --name $cosmosdbname  --resource-group $azureResourceGroup --query connectionStrings[0].connectionString -o tsv --subscription "$subName")

# Create Azure SQL Insance
az sql server create --location $location --resource-group $azureResourceGroup --name $sqldbname --admin-user $adminUser --admin-password $adminPassword --subscription "$subName"

az sql server firewall-rule create --resource-group $azureResourceGroup --server $sqldbname --name azure --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0 --subscription "$subName"

az sql db create --resource-group $azureResourceGroup --server $sqldbname --name tailwind --subscription "$subName"

sqlConnectionString=$(az sql db show-connection-string --server $sqldbname --name tailwind -c ado.net --subscription "$subName")

# ACR Create
az acr create --resource-group $azureResourceGroup --name $acrName --sku Basic --subscription  "$subName" --admin-enabled true

echo "Your Cosmos DB Connection string is: $cosmosConnectionString"
echo 
echo "Your SQL Connection string is: $sqlConnectionString"
