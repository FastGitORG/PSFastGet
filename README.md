# PSFastGet

Powershell stuff to download from fastgit which use github url.

## Install

### From PowerShell Gallery

1. Make sure that you have install PowerShellGet correctly
2. Run `Install-Module -Name FastGet` to install FastGet
3. Run `Import-Module FastGet` to import FastGet
4. Enjoy

### From source file

1. Download FastGet  file
2. Unachive
3. Run `Import-Module $fastget-path` to import FastGet(Change `$fastget-path` to your own path)
4. Run `Import-Module FastGet` to import FastGet
5. Enjoy

## Functions

The following functions are provides by this module.

- Name: ConvertTo-FastGitUrl
  - Description:
    - Convert GitHub url to FastGit url
  - Input:
    - $Url: GitHub url
  - Output:
    - FastGit url
- Name: Get-FastGit
  - Description:
    - Get GitHub things from FastGit
  - Input:
    - $Url: GitHub url
    - $OutFile: save name or path
  - Output:
    - Null

## Alias

| Alias | Function |
| ----- | -------- |
| fget | Get-FastGit |
| fastget | Get-FastGit |

## TODO

1. MultiThread download

## LICENSE

```license
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
```
