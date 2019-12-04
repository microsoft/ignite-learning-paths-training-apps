# APPS30: Modernizing Your Application with Containers

![Learning Path](https://img.shields.io/badge/Learning%20Path-APPS-fe5e00?logo=microsoft) 

## Session Abstract

Tailwind Traders’ recently moved one of its core applications from a virtual machine into containers, gaining deployment flexibility and repeatable builds.

In this session, you’ll learn how to manage containers for deployment, options for container registries, and ways to manage and scale deployed containers. You’ll also learn how Tailwind Traders uses Azure Key Vault service to store application secrets and make it easier for their applications to securely access business critical data.

## Table of Content

| Resources          | Links                            |
|-------------------|----------------------------------|
| PowerPoint        | - [Presentation](presentations.md) |
| Videos            | - [Dry Run Rehearsal](https://globaleventcdn.blob.core.windows.net/assets/apps/apps30/app30-dryrun.mp4) <br/>- [Microsoft Ignite Orlando Recording](https://myignite.techcommunity.microsoft.com/sessions/83032) |
| Demos             | - [Demo 1](example-notes.txt) |

## How To Use

Welcome, Presenter! 

We're glad you are here and look forward to your delivery of this amazing content. As an experienced presenter, we know you know HOW to present so this guide will focus on WHAT you need to present. It will provide you a full run-through of the presentation created by the presentation design team. 

Along with the video of the presentation, this document will link to all the assets you need to successfully present including PowerPoint slides and demo instructions & code.

1.  Read document in its entirety.
2.  Watch the video presentation
3.  Ask questions of the Lead Presenter


## Assets in Train-The-Trainer kit

- This guide
- [PowerPoint presentation](https://globaleventcdn.blob.core.windows.net/assets/apps/apps30/apps30.pptx)
- [Full-length recording of presentation](https://globaleventcdn.blob.core.windows.net/assets/apps/apps30/app30-dryrun.mp4)
- [Full-length recording of from Ignite 2019](https://myignite.techcommunity.microsoft.com/sessions/83032?source=speakerdetail)
- [Full-length recording of presentation - Director Cut](https://www.youtube.com/watch?v=ISQ7EMTvl4U&feature=youtu.be)
- [Demo Instructions](https://github.com/microsoft/ignite-learning-paths/tree/master/apps/apps30)

## Getting Started

To begin the demo you'll need to do a few things which are described in the TTT video:

1. Execute a cloud shell
2. Download the [create-db.sh](https://github.com/microsoft/ignite-learning-paths/blob/master/apps/apps30/create-db.sh) script.
3. Get the [example-notes.txt](example-notes.txt) file for your demonstration live - this will contain your example version of the app you will create live.
4. You'll need the presentation deck, get the latest from the [presentations.md](presentations.md)

We'll use these to prep before we go into the session.  Fully build the application at least before the session. Always keep a preview copy ready to go and build what you can as a demonstration live.  You will demonstrate building the databases live, but well remind the audience we're using "cooking show rules."  You will show the process of creating these databases.

Once you've prepped the app - you're going to build the same app live using the pre-created database information, an incremented name of the app from the one you've created for the demo.

IE: My pre-show demo 

```
az group create --subscription "Ignite The Tour" --name igniteapps30 --location eastus
```

What I will create live: resource group creation notes in [example-notes.txt](example-notes.txt)

```
az group create --subscription "Ignite The Tour" --name 001igniteapps30 --location eastus
```

The incremented name is just to keep it easy to follow.


---

## Creating Resource Group and Databases

Within [create-db.sh](https://github.com/microsoft/ignite-learning-paths/blob/master/apps/apps30/create-db.sh) there are a few bash variables to change.

```
#!/bin/bash
set -e

# Credentials
azureResourceGroup=igniteapps30
adminUser=twtadmin
adminPassword=twtapps30pD
subname=cd400f31-6f94-40ab-863a-673192a3c0d0
location=eastus

# DB Name

cosmosdbname=apps30twtnosql
sqldbname=apps30twtsql
```

I do the same incrementing of the name for the "live" version.  I create these before hand but then demonstrate how to create from portal.  The versions I do from portal I do not "deploy" - before I "create and deploy" I explain for time we've already created our DB's with Azure SQL and Cosmos DB.

Example:

Live Version - 

```
#!/bin/bash
set -e

# Credentials
azureResourceGroup=igniteapps30
adminUser=twtadmin
adminPassword=twtapps30pD
subname=cd400f31-6f94-40ab-863a-673192a3c0d0
location=eastus

# DB Name

cosmosdbname=apps30twtnosql
sqldbname=apps30twtsql
```

Once you've edited the script lets run it in bash Cloud Shell and begin process of building demo.

```
bash create-db.sh
```

This should take about 15 minutes for both DBs to create.

Collect both connection strings to put in the VARs for the container to connect to the database.

## Next Steps

Go through the opening of the talk with the application fully built in the background.  Keep two portals up, one with the "complete" version of the app, one of the resource group you're going to build live.  You'll want to show them the difference and how you're creating the resources live as you're explaining each part.

## Demoing Live

Run through the demo using [example-notes.txt](example-notes.txt) file.

1. Create Resource Group Cloud Shell (it's already created, but that's fine)
2. Create VNET in Cloud Shell (then show them the vnet in portal)
3. Example Create CosmosDB (show them the databases created by create-db.sh in the portal)
4. Example Create Azure SQL (show them the databases created by create-db.sh in the portal)
5. Clone repo in Cloud Shell, check into `monolith` branch in notes file
6. Create ACR in Cloud Shell (show them completed in portal)
7. ACR BUILD image in Cloud Shell (show them created image in PORTAL)
8. Create App Service INCLUDING Plan for containers IN PORTAL(CLICK THROUGH STEPS)
9. Select ACR and image in the Web App container settings in IN PORTAL (CLICK THROUGH STEPS)
10. Show them APPLICATION SETTINGS and then show how to enter envrionment variables (do one), use your pre-show created version to then show all the VARs.
11. Navigate to "pre-show" app with all settings, show the audience app, including inventory of an item.
12. Delete both when completed.

## Become a Trained Presenter

To become a trained presenter, contact [scalablecontent@microsoft.com](mailto:scalablecontent@microsoft.com). In your email please include:

- Complete name:
- The code of this presentation: apps30
- Link (ex: unlisted YouTube video) to a video of you presenting (~10 minutes). 
  > It doesn't need to be this content, the important is to show your presenter skills

A mentor will get back to you with the information on the process.

## Trained Presenters

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->

<table>
<tr>
    <td align="center"><a href="http://cloud5mins.com/">
        <img src="https://avatars1.githubusercontent.com/u/2974195?s=400&u=9ab103b405a40dfeec2302ff0fb7700685d66915&v=4/u/2404846?s=460&v=4" width="100px;" alt="Jay Gordon"/><br />
        <sub><b>Jay Gordon</b></sub></a><br />
            <a href="https://github.com/neilpeterson/ignite-tour-fy20/commits?author=jaydestro" title="talk">📢</a>
            <a href="https://github.com/neilpeterson/ignite-tour-fy20/commits?author=jaydestro" title="Documentation">📖</a> 
    </td>
</tr></table>

<!-- ALL-CONTRIBUTORS-LIST:END -->

