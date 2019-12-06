# Deployments

## Required Software

1. Install [Visual Studio Code](https://code.visualstudio.com/) 
1. Install the [Remote extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) for VSCOde. 
1. You will need [SSH Client](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse) installed. 
    * If you need a set of keys, open a terminal and execute the command `ssh-keygen -t rsa -b 2048` remember where you put the information (usually C:\Users\<USERNAME>/.ssh/ ) and your passphrase (aka password). 
1.  For sharing Android device: [Vysor](http://www.vysor.io/)


There is multiple things to deploy. Before we start presenting we want to have those things already deployed:

1. The Tailwind Traders solution Standalone deployment
2. The Tailwind Traders solution Frontend in a ScaleSet VM and backend as Services
3. Images of Tailwind Traders VM in a Shared Gallery
4. A Key Vault with a secret containing the SQL database connection
5. Mobile App
6. Connect/ Share mobile screen on laptop


## 1 - The Tailwind Traders solution Standalone

To deploy this solution you just have to click the **Deploy to Azure**, and select **Standalone**.

**Note** - If you get an error during the deployment, check the resource group in the portal to see if it's still deploying.  When the deployment completes, check the Website created by the App service to see if it's working. If the Website is working, then the deployment was successful.  Otherwise please try the deployment in a different region.  

We are working on a solution for this issue.

[![Deploy to Azure](https://azuredeploy.net/deploybutton.svg)](https://deploy.azure.com/?repository=https://github.com/Microsoft/TailwindTraders-Website/tree/master)

![standalone][standalone]

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

> ☝ Test your connection From VSCode (See [Demo 1](../demos/README.md#demo-1---lets-create-a-vm))

<!--
- Deploy VM scale sets version 
    > Inspired from : the VM version here https://github.com/neilpeterson/tailwind-reference-deployment

    <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fignite-learning-paths%2Fmaster%2Fapps%2Fapps10%2Fdeployment%2Fazure-deploy-paas.json?WT.mc_id=ignite-github-frbouche" target="_blank"><img src="https://azuredeploy.net/deploybutton.png"/></a>

-->

Let's create a VM scaleset with Azure CLI

    az group create --name apps10demo-vmscale --location eastus

    az vmss create --resource-group apps10demo-vmscale --name apps10ScaleSet --image "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/Tailwind-Shared/providers/Microsoft.Compute/galleries/TailwindShared/images/tailwind-demo1" --upgrade-policy-mode automatic --admin-username frankyadmin --ssh-key-value "C:\Users\frank\.ssh\id_rsa.pub"

## 3. Images of Tailwind Traders VM in a Shared Gallery

> Right now there is no real Tailwind image ready to be use in a scale set. We will fake this for now.

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

Once the key vault is created, We will need to provide some security, a Service Principal, for the WebApp so it can access the Key Vault and have **read** access to the secret.

### Create a Service Principal for the WebApp

- In another tab, Open the WebApp. (Using 2 tabs will simplify the back& forward between those two).
- From the left menu click on **Identity**. 
- We now assigning a Service Principal for our WebApp by changing the status to *on*.
- Don't forget to **Save**. And when ask to *Enable system assigned managed identity* click Yes.

  ![Create Service Principal][CreateServicePrincipal]


### Give To the WebApp the Permission

- Go back in the Key Vault, and click **Access policies**, than **+ Add Access Policy** button.

  ![Add Access Policies][AccessPolicies]

- Set the **Configuration from template** to Secret Management. This will check 7 permission in the Secret Permission list.
- Expand **Select Principal** section.
    * Type the name of the WebAPP. Alternatively you can also search by using the ObjectID provided by the portal after you assigned the Service Principal.
    * Click on the WebApp to select it, and click the **Select** button at the bottom of the screen.
    * Select the Add button.

      ![Grant Access][GrantAccess]

- DON'T FORGET TO SAVE!

  ![Save Save Save][SaveSaveSave]


### Create the Secret in Key Vault

Now that we have a Key Vault and that the WebApp has access to it let's add a secret. We will move the SQL Connection string in the KeyVault and let the WebApp read it from there.

- First, we need the **SqlConnectionString** (that's our secret)
    * From the PaaS solution, select the App Service (aka. Webapp) 
    * From the left panel select Configuration
    * Click on the **SqlConnectionString** row and note the value.
- Now let's create the secret
    * Open the Key Vault
    * From the left panel, click on secret
    * Click the **+ Generate/Import** 

      ![Create Secrets][CreateSecrets]

    * Give it a name (ex: secretConStr), and paste in value the connecctionstring value (ex: Server=tcp:tailwindtraders-apps10-s...)
    * Then Click the Create blue button.
- Click on the Secret you created
- Click again on the secret it should look like a GUID
- Note (put it in the Clipboard) the URL contain in the **Secret identifier**

  ![Save Secret URL][SaveSecretURL]

- Re-open the App Service, and re-open the **SqlConnectionString** in the setting, by clicking the edit button.
- Replace the current value by: `@Microsoft.KeyVault(SecretUri=URL_FROM_KEYVAULT)`, where *URL_FROM_KEYVAULT* is replaced by the url you got from the key vault.
- Click the *Ok* button in the bottom of the screen.
- Click the Save button on the top of the page.
- Once it's done saving, click the refresh button. You should see now a *Key vault Reference*, with a green check beside your setting.

  ![Success][Success]

> If you see it in Red, Check again that you saved correctly the Service Principal, the rules, and the secret.


## 5- Mobile App

> The mobile app currently is only available for phones. Devices such as Tablets (iPad) will not work

- Locate and install the Tailwind Traders app on your device's app store.
    - On the mobile device navigate to the URL: aka.ms/tailwind-droid (for Android)
- Login to app with fake email and password.
- After logging in, go to Menu > Settings ![settings][settings]
- Update Product Service API URL with url of deployed Tailwind Traders website as done in [1 - The Tailwind Traders solution full PaaS](#1---the-tailwind-traders-solution-full-paas).
- Save your changes with the "Save" button at the bottom.
- Can't access the app after troubleshooting? Contact Matt Soucoup for assistance

## 6- Connect/ Share mobile screen on laptop

- Open Vysor. 
- Connect your mobile to your laptop using a USB cable. 
- For Android:
    - Your phone must be in developer mode.
    - Open the Settings app. Select System.
    - Scroll to the bottom and select About phone.
    - Scroll to the bottom and tap Build number 7 times.
    - Return to the previous screen to find Developer options near the bottom.
    - Set USB debugging to True (in Debugging section)
- Accept all the permission request... you should see your mobile screen in your laptop after a few seconds


[standalone]: ../assets/standalone.png
[settings]: ../assets/settings.jpg
[CreateSecrets]: ../assets/CreateSecrets.png
[SaveSecretURL]: ../assets/SaveSecretURL.png
[CreateServicePrincipal]: ../assets/CreateServicePrincipal.png
[AccessPolicies]: ../assets/AccessPolicies.png
[GrantAccess]: ../assets/GrantAccess.png
[SaveSaveSave]: ../assets/SaveSaveSave.png
[Success]: ../assets/Success.png
