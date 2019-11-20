# Ignite Learning Paths - APPS Learning Path

![Learning Path](https://img.shields.io/badge/Learning%20Path-APPS-fe5e00?logo=microsoft)  ![Session](https://img.shields.io/badge/🗣️Sessions-6-31c754)

Welcome!

The content of this repository is available for you so you can reproduce any demo or learn how to present any session of the Learning Path presented at [Migrosoft Ignite](https://www.microsoft.com/en-us/ignite) and during [Microsoft Ignite The Tour](https://www.microsoft.com/en-ca/ignite-the-tour/).

## Do the Demos

If you are here to reproduce a demo in the comfort of your home/office, go in in the section [Sessions](#sessions). In each session you will find deployment instructions, to create the environment you need, and a tutorial to do the demo step by step.

## Presenting the content

We're glad you are here and look forward to your delivery of this amazing content. As an experienced presenter, we know you know HOW to present so this guide will focus on WHAT you need to present. It will provide you a full run-through of the presentation created by the presentation design team.

Along with the video of the presentation, this repository will link to all the assets you need to successfully present including PowerPoint slides and demo instructions & code.

## Sessions

Here all the sessions available in the learning path **Building Applications for the Cloud** (aka: **APPS**)

### [**APPS10**: Options for Building and Running Your App in the Cloud](./apps10/README.md)

We’ll show you how Tailwind Traders avoided a single point of failure, using cloud services to deploy their company website to multiple regions. We’ll cover all the options they considered, explain how and why they made their decisions, then dive into the components of their implementation.  

In this session, you’ll see how they used Microsoft technologies like VS Code, Azure Portal, and Azure CLI to build a secure application that runs and scales on Linux and Windows VMs and Azure Web Apps, with a companion phone App. 


### [**APPS11**: Related 15 Theater minute session - Azure and the Command Line – Options, Tips, and Tricks](./apps11/README.md)

If you love working from the command line, or just want to know what you can do, this session will cover all the things you need to know to get the most out of the experience on Windows, Mac and Linux.  We’ll start with Windows command line, then the new Terminal, and the Windows Subsystem for Linux (WSL).  Then we’ll cover some interesting developments in the Azure cloud shell and show you how you can work with command line options VS Code.  By the end of this 15 minute session you’ll have some new and interesting ways to control the cloud from your keyboard!


### [**APPS20**: Options for Data in the Cloud](./apps20/README.md)

Abstract: Tailwind Traders is a large retail corporation, with a dangerous single point of failure: sales, fulfillment, monitoring, and telemetry data is centralized across its online and brick and mortar outlets. We’ll review structured databases, unstructured data real-time data, file storage considerations, and share tips on balancing performance, cost, and operational impacts.

In this session, you’ll learn how Tailwind Traders created a flexible data strategy using multiple Azure services, such as AzureSQL, CosmosDB, the CosmosDB Mongo API, and more – and how to overcome common challenges and find the right storage option.


### [**APPS30**: Modernizing Your Application with Containers  ](./apps30/README.md)

Tailwind Traders’ recently moved one of its core applications from a virtual machine into containers, gaining deployment flexibility and repeatable builds.

In this session, you’ll learn how to manage containers for deployment, options for container registries, and ways to manage and scale deployed containers. You’ll also learn how Tailwind Traders uses Azure Key Vault service to store application secrets and make it easier for their applications to securely access business critical data.



### [**APPS40**: Consolidating Infrastructure with Azure Kubernetes Service](./apps40/README.md)

Kubernetes is the open source container orchestration system that supercharges applications with scaling and reliability and unlocks advanced features, like A/B testing, Blue/Green deployments, canary builds, and dead-simple rollbacks.

In this session, you’ll see how Tailwind Traders took a containerized application and deployed it to Azure Kubernetes Service (AKS). You’ll walk away with a deep understanding of major Kubernetes concepts and how to put it all to use with industry standard tooling.



### [**APPS50**: Taking Your App to the Next Level with Monitoring, Performance and Scaling](./apps50/README.md)

Making sense of application logs and metrics has been a challenge at Tailwind Traders. Some of the most common questions getting asked within the company are: “How do we know what we're looking for? Do we look at logs? Metrics? Both?” Using Azure Monitor and Application Insights helps Tailwind Traders elevate their application logs to something a bit more powerful: telemetry. In session, you’ll learn how the team wired up Application Insights to their public-facing website and fixed a slow-loading home page. Then, we expand this concept of telemetry to determine how Tailwind Traders’ fixes issues present in an Azure Kubernetes Service cluster. Finally, we’ll look into capacity planning and scale with powerful yet easy services like Azure Front Door.


## Contributing

To know more about about to contribute to this project please refer to the [Code of Conduct](CODE_OF_CONDUCT.md) and [Contributing](CONTRIBUTING.md) page.


## Become a Trained Presenter

You don't need anything to present this content, it's all there to be used. However, by becoming a *Trained Presenter* the scalable content team will recognize you as tell. *Trained Presenter* see their contact information (name, picture, website) in the bottom of each session.  
 
To become a *Trained Presenter*, contact [scalablecontent@microsoft.com](mailto:scalablecontent@microsoft.com). In your email please include:

- Complete name:
- The code of this presentation: \<Session Code (ex:apps10)\>
- Link (ex: unlisted YouTube video) to a video of you presenting (~10 minutes). 

> It doesn't need to be this content, the important is to show your presenter skills


## Legal Notices

Microsoft and any contributors grant you a license to the Microsoft documentation and other content in this repository under the [Creative Commons Attribution 4.0 International Public License](https://creativecommons.org/licenses/by/4.0/legalcode), see the [LICENSE](LICENSE) file, and grant you a license to any code in the repository under the [MIT License](https://opensource.org/licenses/MIT), see the [LICENSE-CODE](LICENSE-CODE)

Microsoft, Windows, Microsoft Azure and/or other Microsoft products and services referenced in the documentation may be either trademarks or registered trademarks of Microsoft in the United States and/or other countries. The licenses for this project do not grant you rights to use any Microsoft names, logos, or trademarks. Microsoft's general trademark guidelines can be found at http://go.microsoft.com/fwlink/?LinkID=254653.

Privacy information can be found at https://privacy.microsoft.com/en-us/

Microsoft and any contributors reserve all other rights, whether under their respective copyrights, patents, or trademarks, whether by implication, estoppel or otherwise.
