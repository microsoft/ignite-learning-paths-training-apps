# Technical Demonstrations

| [README](/apps11/README.md) | [Slides](/apps11/slides/README.md) | [Demos](/apps11/demos/README.md) | 

## Pre-delivery Preparation

Before delivering the technical demonstrations, you will want to prepare a few things to save time and to create a demonstration audience members can follow.

Be sure to address each item on the presenter setup checklist below.

>**Presenter Setup Checklist:**

Note - These demos need Windows to run WSL and the Terminal
- [ ] Install WSL 2 - https://github.com/microsoft/WSL
- [ ] Install the Azure CLI - https://github.com/Azure/azure-cli
- [ ] Install the Microsoft Terminal - https://github.com/Microsoft/Terminal
- [ ] Install Visual Studio Code 
- [ ] Install the remote host extension in Visual Studio Code 
- [ ] Open Terminal and from the drop-down select settings, make sure that profiles.json opens in Visual Studio Code
- [ ] Customize profiles.json with your own demos, or use the provided profiles.json as a base.  
- [ ] Create a VM with SSH keys
- [ ] Create a host connection configuration file in VS Code
- [ ] Log in to Cloud Shell (https://shell.azure.com/) with a valid Azure subscription
- [ ] Open these URLs in a browser:
     - [ ] https://github.com/microsoft/WSL
     - [ ] https://github.com/Azure/azure-cli
     - [ ] https://github.com/Microsoft/Terminal
     - [ ] https://github.com/Microsoft/MS-DOS
     - [ ] https://shell.azure.com/

## Demo Timing

There are three (3) separate demos.

NOTE - The video and demos runs longer than 20 minutes as I've provided more demos than necessary - It's up to each presenter to choose personalized demos from those offered, using the provided profiles.json as a base, or make up their own.  

| Section / Demo | Minutes | Slides | Video

|[1 - Opening command prompt, VS code,wsl and powershell from file explorer](https://youtu.be/3hTbtZaTek0?t=89)|2 | *3 - 6* | [Link](https://youtu.be/3hTbtZaTek0?t=89)
|[2 - Customized Windows Terminal](https://youtu.be/3hTbtZaTek0?t=496)|5 | *7 - 10* | [Link](https://youtu.be/3hTbtZaTek0?t=496)
|[3 - Connecting to a VM via Visual Studio Code Remote Window](https://youtu.be/3hTbtZaTek0?t=1058)|3 | *11 - 13* |[Link](https://youtu.be/3hTbtZaTek0?t=1058)
|
| Total       |8 | |


### [Demo 1: Opening command prompt, VS code, WSL and powershell from file explorer](https://youtu.be/3hTbtZaTek0?t=89)

> 💡 You must have completed the [deployment](#pre-delivery-preparation) before attempting to do the demo.

**What are we trying to demonstrate?**

This is the first on-stage technical demonstration for the presentation.  
We want to quickly highlight a little-known capability to open command prompts from File Explorer

This demo uses the following:

-File Explorer, WSL, CMD, Powershell and VS Code 

Demo 
-Open a windows folder, type CMD
-Open VS Code by typing code . in the command prompt
-Same Folder, type powershell
-Same Folder, type wsl-Same Folder, type code

---

### [Demo 2: Customized Windows Terminal](https://youtu.be/3hTbtZaTek0?t=496)

> 💡 You must have completed the [deployment](#pre-delivery-preparation) before attempting to do the demo.

**What are we trying to demonstrate?**

Show off a customized Terminal

This demo uses the following:

- Microsoft Terminal
- The versions of WSL, CMD, and Powershell installed on your machine.

---

### [Demo 3: Connecting to a VM via Visual Studio Code Remote Window](https://youtu.be/3hTbtZaTek0?t=1058)

> 💡 You must have completed the [deployment](#pre-delivery-preparation) before attempting to do the demo.

**What are we trying to demonstrate?**

How to connect to a VM from VS Code, navigate folders edit files.

Demo 
-Open Cmd in VS Code
-CTRL-SHIFT-P – Change to WSL
-Open WSL in VS Code
-CTRL-SHIFT-P – Open Bash in Cloud Shell-Open Cloud Shell in VS Code 
-Open Cloud Shell in VS Code to full screen
-Go to shell.azure.com  
-type code .
-Point out the differences between VS Code and code . In shell


This demo uses the following:

- VS Code 
- Azure VMs

---


