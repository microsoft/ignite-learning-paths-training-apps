# APPS10: Options for Building and Running Your App in the Cloud  

## Session Abstract

We’ll show you how Tailwind Traders avoided a single point of failure, using cloud services to deploy their company website to multiple regions. We’ll cover all the options they considered, explain how and why they made their decisions, then dive into the components of their implementation.  

In this session, you’ll see how they used Microsoft technologies like VS Code, Azure Portal, and Azure CLI to build a secure application that runs and scales on Linux and Windows VMs and Azure Web Apps, with a companion phone App.  

The session [Ignite Learning Paths - APPS10](https://github.com/microsoft/ignite-learning-paths/tree/master/apps/apps10).

## How To Use

Welcome, Presenter! 

We're glad you are here and look forward to your delivery of this amazing content. As an experienced presenter, we know you know HOW to present so this guide will focus on WHAT you need to present. It will provide you a full run-through of the presentation created by the presentation design team. 

Along with the video of the presentation, this document will link to all the assets you need to successfully present including PowerPoint slides and demo instructions &
code.

1.  Read document in its entirety.
2.  Watch the video presentation
3.  Ask questions of the Lead Presenter


## Assets in Train-The-Trainer kit

- This guide
- [PowerPoint presentation](https://#)
- [Full-length recording of presentation](https://#)
- [Full-length recording of presentation - Director Cut](https://youtu.be/0kGGhoEB-48)
- [Demo Instructions](demos/demo-instructions.md)
  

## Get Started

This training repository is divided in to the following sections:

| [Slides](#slides) | [Demos](demos/demo-instructions.md) | [Deployment](deployment/readme.md) | 
|-------------------|---------------------------|--------------------------------------
| 42 slides - 25 minutes, | 4 demos - 20 minutes, | 1 automated deployment

 [Full-length video can be viewed here (Coming Soon..)](https://coming.soon).

## Slides

The slides are divided in five sections:

 Section                    | Slides           | Notes
----------------------------|---------------   |------
Introduction                | 1-9              | There more here because it's the first talk of the Learning Path
Deployment Tools            | 10-16            | 
Deployment Options          | 17-23, 24*, 25*   | 
Basic Security feature      | 26-29, 30*, 31-33 |
Xamarin                     | 34-35, 36*,       | 

*slide demo

### Timing

| Time        | Description 
--------------|-------------
0:00 - 5:00   | Intro to the session, app 
5:00 - 15:00  | Tools for Cloud Development – VS, VSCode, Azure CLI, Terminal, ARM 
15:00 - 20:00 | Options for deployment - VMs/Scale Sets, ACI/AKS, Web Apps, Azure Blob Static Websites  
20:00 - 35:00 | **Demos** – creating a VM, remote options, deploying to VM scale sets and Web app for Linux  
35:00 - 40:00 | **Demo** - Securing the app with Azure Key Vault 
40:00 - 45:00 | **Demo** - Adding a Phone App with Xamarin 

## Deployment / Preparation

The following steps are necessary to prepare for APPS10 demos.

### Required Software

1. Install [Visual Studio Code](https://code.visualstudio.com/) 
1. Install the [Remote extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) for VSCOde. 
1. You will need [SSH Client](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse) installed. 
    * If you need a set of keys, open a terminal and execute the command `ssh-keygen -t rsa -b 2048` remember where you put the information (usually C:\Users\<USERNAME>/.ssh/ ) and your passphrase (aka password). 

### Suggested setup to present

> You should have a few things open a ready:

- PowerPoint
- Browser Tab: Portal Azure Dashboard/ home
- Browser Tab: Tailwind traders website (from PaaS solution)
- Browser Tab: Scale sets Resource Group
- Browser Tab: PaaS Resource Group
- Browser Tab: Key Vault
- Visual Studio Code, with the Azure CLI to create a scale set
    ```
    az vmss create \
        -g $RGName \
        -n myScaleSet \
        --image "/subscriptions/<subscription ID>/resourceGroups/myGalleryRG/providers/Microsoft.Compute/galleries/myGallery/images/myImageDefinition/versions/1.0.0" \
        --admin-username azureuser \
        --generate-ssh-keys
   ```
- ZoomIt (or another application that zoom your screen) should be running, there is tiny stuff to show.


## Demos

> What's Here? Pre-delivery preparation, stage ready videos, required files (such as JSON templates), and walk-through videos

Detailed explanations of each demonstration associated with this presentation can be found in this section. There are 3 "live from stage" technical demonstrations that utilize a number of tools both in and out of Azure. [You can get a high level overview of the tools and how we will be using them here](demos/demo-instructions.md).

| Demo 	                                    | Minutes | Video
--------------------------------------------|---------|-----------------
|  [1 - Let’s Create a VM ](demos/demo-instructions.md#demo-1---lets-create-a-vm)            | ?       | [Link]()
|  [2 - Alternative PaaS - WebApp](demos/demo-instructions.md#demo-2---plan-b-paas---webapp)  | ?       | [Link]()
|  [3 - Securing the app with Azure Key Vault](demos/demo-instructions.md#demo-3---securing-the-app-with-azure-key-vault) | ?       | [Link]()
|  [4 - Quick look at the Tailwind Traders App](demos/demo-instructions.md#demo-4---quick-look-at-the-tailwind-traders-app) | ?       | [Link]()

## Become a Presenter

To become a certified presenter, contact [learningpathmanager@microsoft.com](mailto:learningpathmanager@microsoft.com). In your email please include:

- Complete name:
- The code of this presentation: apps10
- Link (ex: unlisted YouTube video) to a video of you presenting (~10 minutes). 
  > It doesn't need to be this content, the important is to show your presenter skills

A mentor will get back to you with the information on the process.

## Certified Presenters

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<table>
<tr>
    <td align="center"><a href="http://cloud5mins.com/">
        <img src="https://avatars2.githubusercontent.com/u/2404846?s=460&v=4" width="100px;" alt="Frank Boucher"/><br />
        <sub><b>Frank Boucher</b></sub></a><br />
            <a href="https://github.com/neilpeterson/ignite-tour-fy20/commits?author=fboucher" title="talk">📢</a>
            <a href="https://github.com/neilpeterson/ignite-tour-fy20/commits?author=fboucher" title="Documentation">📖</a> 
    </td>
</tr></table>

<!-- ALL-CONTRIBUTORS-LIST:END -->