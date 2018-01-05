# powershell-scripts

A tiny collection of **PowerShell-Scripts** I use on a regular basis.

[![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic)](https://github.com/mmuyakwa/bash-scripts/blob/master/LICENSE) [![approved](https://img.shields.io/badge/approved-by%20Mein%20Nachbar-green.svg?style=plastic)](https://encrypted.google.com/search?q=steffen+held) [![powered_by](https://img.shields.io/badge/part%20of-Likando%20Publishing-red.svg?style=plastic)](https://www.likando.de)

## Table of Contents

<!-- toc -->

* [CreateNewWorkspace.ps1](#create-new-workspace) - For my daily Workbench
* [Running these scripts](#running-these-scripts) - Working with these PowerShell-Scripts

<!-- toc stop -->

## Create New Workspace

This creates a new folder in my folder 

```php

'C:\Users\your-profilename\Documents\Workspace\("CURRENT_YEAR")\("CURRENT_MONTH"))\("YYYY-MM-dd")'

```

For my daily projects I start a new folder with the current Date.

(e.g.: "c:\MyWorkspace\2017\12\2017-12-24")

## Running these scripts

e.g.:

Generate a link on your Desktop pointing to:

    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\Path_to_your\PowershellScript.ps1"

MIT License
