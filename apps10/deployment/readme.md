# Deployments

Before we start presenting we want to have those things already deployed:

1. The Tailwind Traders solution full PaaS
2. The Tailwind Traders solution Frontend in a ScaleSet VM and backend as Services
3. Images of Tailwind Traders VM in a Shared Gallery
4. A Key Vault with a secret containing the SQL database connection

> 🚩Note: Right now there is a lot of manual steps. This will be updated. 

## 1 - The Tailwind Traders solution full PaaS

To deploy this solution you just have to click the **Deploy to Azure**, and select *Standalone*.

[![Deploy to Azure](https://azuredeploy.net/deploybutton.svg)](https://deploy.azure.com/?repository=https://github.com/Microsoft/TailwindTraders-Website/tree/master)

<!--
- Deploy Full PaaS version (with Key vault)
    > Inspired from : https://gist.github.com/anthonychu/9ab34d2991fb5c1c0c29faeebbe43a51#file-tailwind-deployments-md

    <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fignite-learning-paths%2Fmaster%2Fapps%2Fapps10%2Fdeployment%2Fazure-deploy-paas.json?WT.mc_id=ignite-github-frbouche" target="_blank"><img src="https://azuredeploy.net/deploybutton.png"/></a>
-->

## 2. The Tailwind Traders solution Frontend in a ScaleSet VM and backend as Services

Right now there is no deployment/ ARM done for this. Since we just need to show how to connect and scale... Create a scale sets deployment with a ubuntu vm.

- From portal.azure.com
- Click +, and type "Virtual machine scale set", then click the button create.
    * Use Ubuntu Server 18.04 LTS
    * Select SSH public key as **Authentication type**
    * 2 instances are enough
    * Allow inbound port SSH(22)
- Click Create.

> ☝ Test your connection From VSCode (See Demo to know how.)

<!--
- Deploy VM scale sets version 
    > Inspired from : the VM version here https://github.com/neilpeterson/tailwind-reference-deployment

    <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fignite-learning-paths%2Fmaster%2Fapps%2Fapps10%2Fdeployment%2Fazure-deploy-paas.json?WT.mc_id=ignite-github-frbouche" target="_blank"><img src="https://azuredeploy.net/deploybutton.png"/></a>

-->

## 3. Images of Tailwind Traders VM in a Shared Gallery

Right now there is no real Tailwind image ready to be use in a scale set. We will fake this for now.

> 💡Always use the same location to be able to see/ use your images

- Create a simple Linux VM
- Once the VM is deployed. open the the blade in the portal
- Create an image by clicking the button capture (you can check to delete the vm once image is created)
- Click +, and type "Shared Image Gallery", then click the button create.
- Give it a name, etc. etc. Create.
- Once created, open the Shared Image Gallery.
- Click the **+ Add new image definition**
    * Give it a Name, Region (same), Invent a Publisher, Offer, SKU
    * Click the Review Create....
- Once the image definition is created, click on it.
- Click on **+ Add version**
    * Select the capture done previously as Source image 
    * Fill the rest of the form.

## 4 - A Key Vault with a secret containing the SQL database connection

Eventually the key vault will be created and populated during the PaaS deployment. For now it's manual.

- From portal.azure.com
- Click +, and type "Key Vault", then click the button create.
- Give it a name, I suggested you create the Key Vault in the same Resource Group as the PaaS demo. This is where it will be when the process will be automatic.

Once the key vault is created we will add a secret, and populate it.
- First, we need the **SqlConnectionString** (that's our secret)
    * From the PaaS solution, select the App Service (aka. Webapp) 
    * From the left panel select Configuration
    * Click on the **SqlConnectionString** row and note the value.
- Now let's create the secret
    * Open the Key Vault
    * From the left panel, click on secret
    * Click the **+ Generate/Import**
    * Give it a name (ex: secretConStr), and paste in value the connecctionstring value (ex: Server=tcp:tailwindtraders-apps10-s...)
- Click on the Secret you created
- Click again on the secret it should look like a GUID
- Save the URL contain in the **Secret identifier**
- Re-open the App Service, and re-open the **SqlConnectionString** in the setting
- Replace the current value by: `@Microsoft.KeyVault(SecretUri=URL_FROM_KEYVAULT)`, where *URL_FROM_KEYVAULT* is replaced by the url you got from the key vault.
- Restart the App Service, and test if it's working. It should.  
