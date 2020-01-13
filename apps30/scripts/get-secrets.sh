#!/bin/bash

# example command:
# sh scripts/get-secrets.sh

set -e

# Set the following
spName=tailwindtraders30
resourceGroup=igniteapps30
adminUser=twtadmin
adminPassword=twtapps30pD
subName="Ignite The Tour"
cosmosDBName=apps30twtnosqlge
sqlDBName=apps30twtsql
acrName=igniteapps30acr

# set the subscription
az account set --subscription "$subName" && echo "Your default subscription has been set to: $subName"

# Create a service principal
    echo "Creating service principal..."
    spInfo=$(az ad sp create-for-rbac --name "$spName" \
            --role contributor \
            --sdk-auth)

    if [ $? == 0 ]; then
        # get acr name
        echo "Retrieving Container Registry info..."
        acrName=$(az acr list -g $resourceGroup -o tsv --query "[0].name")

        # get mongo connection string
        cosmosConnectionString=$(az cosmosdb list-connection-strings --name $cosmosDBName  --resource-group $resourceGroup --query connectionStrings[0].connectionString -o tsv --subscription "$subName")

        # get sql connection string
        sqlConnectionString=$(az sql db show-connection-string --server $sqlDBName --name tailwind -c ado.net --subscription "$subName" | jq -r .)

        echo '========================================================='
        echo 'GitHub secrets for configuring GitHub workflow'
        echo '========================================================='
        echo "AZURE_CREDENTIALS: $spInfo"
        echo "SQL_ADMIN: $adminUser"
        echo "SQL_PASSWORD: $adminPassword"
        echo "MONGODB_CONNECTION_STRING: $cosmosConnectionString"
        echo "SQL_CONNECTION_STRING: $sqlConnectionString"
        echo "CONTAINER_REGISTRY: $(az acr list -g $resourceGroup -o tsv --query [0].loginServer)"
        echo "REGISTRY_USERNAME: $(az acr credential show -n $acrName --query username -o tsv)"
        echo "REGISTRY_PASSWORD: $(az acr credential show -n $acrName -o tsv --query passwords[0].value)"
        echo '========================================================='
    else
        "An error occurred. Please try again."
         exit 1
    fi
