#
# Convert GitHub url to FastGit url
#
# $Url: GitHub url
# return: FastGit url
function ConvertTo-FastGitUrl {
<#
    .Synopsis
        Convert GitHub url to FastGit url
    .Description
        Convert GitHub url to FastGit url
    .Example
        ConvertTo-FastGitUrl -url "https://github.com/dotnet/installer/archive/v3.1.201.zip"
        This will get the FastGit url of https://github.com/dotnet/installer/archive/v3.1.201.zip
    .Inputs
        Url: GitHub url
    .Outputs
        return: FastGit url
    .Notes
        The script is built by FastGit member(@KevinZonda)
#>
    param (
        [Parameter(Mandatory=$True)]
        [string]$Url
    )

    $Url = $Url.Replace("//hub.fastgit.org", "//github.com")

    if ($Url.StartsWith("https://github.com")) {
        $_SplitUrl = $Url.Replace("https://github.com/", "").Split('/');
        if (($_SplitUrl[2].ToLower() -eq "raw") -or  ($_SplitUrl[2].ToLower() -eq "blob")) {
            # Convert to RAW
            $_Result = "https://raw.fastgit.org/";
            for ($i = 0; $i -lt $_SplitUrl.Length; ++$i) {
                if($i -ne 2) {
                    $_Result += $_SplitUrl[$i] + "/"
                }
            }
            return $_Result.Substring(0, $_Result.Length - 1)
        }
        elseif (($_SplitUrl[2].ToLower() -eq "releases") -or ($_SplitUrl[2].ToLower() -eq "archive")) {
            # Convert to Download
            return $Url.Replace("https://github.com", "https://download.fastgit.org")
        }
        else {
            return $Url
        }
    }
    elseif ($Url.StartsWith("https://raw.githubusercontent.com/")) {
        return $Url.Replace("https://raw.githubusercontent.com/", "https://raw.fastgit.org/")
    }
    elseif ($Url.StartsWith("https://codeload.github.com")) {
        $Url = $Url.Replace("https://codeload.github.com", "https://download.fastgit.org")
        if ($Url.EndsWith(".zip") -eq 0) {
            $Url += ".zip"
        }
        return $Url
    }
    else {
        # This is not github url
        return $Url
    }
}

#
# Get things from FastGit
#
# $Url: GitHub url
# $OutFile: save name or path
# return: null
function Get-FastGit {
<#
    .Synopsis
        Get things from FastGit
    .Description
        Get things from FastGit
    .Example
        Get-FastGit -Url "https://github.com/dotnet/installer/archive/v3.1.201.zip"
        GitHub url will convert to FastGit url. Please refer to ConvertTo-FastGitUrl for more information.
        This will download file with FastGit url of https://github.com/dotnet/installer/archive/v3.1.201.zip
    .Inputs
        Url: GitHub url
    .Notes
        The script is built by FastGit member(@KevinZonda)
#>

    param (
        [Parameter(Mandatory=$True)]
        [string]$Url,
        [string]$OutFile
    )

    $Url = ConvertTo-FastGitUrl $Url

    # Get filename
    $_SplitUrl = $Url.Split('/');
    if ($_SplitUrl.Length -eq 0) {
        throw "$Url is invalid."
    } 

    $filename = $_SplitUrl[$_SplitUrl.Length - 1];

    if ($OutFile) {
        if($OutFile.EndsWith("\\") -or $OutFile.EndsWith("/")) {
            $OutFile += $filename
        }
    }
    else {
        $OutFile = $filename
    }
    $Uri=$Url.Replace("https://", "").Replace("http://", "")
    Write-Verbose "URL -> $Url"
    Write-Verbose "URI -> $Uri"
    Write-Verbose "OutFile -> $OutFile"

    Write-Verbose "Test if file exists"
    if (Test-Path $OutFile)
    {
        Write-Host "A file with the same name exists. Do you want to cover it? (Default is No)" -ForegroundColor Yellow 
        $Readhost = Read-Host " (y/n) " 
        Switch ($ReadHost.ToString().ToLower()) 
        { 
            "y" {
                Invoke-WebRequest -Uri $Uri -OutFile $OutFile
            } 
            Default {
                Write-Output "Operation cancled."
            } 
        }
    }

}

New-Alias -Name fget -value Get-FastGit
New-Alias -Name fastget -value Get-FastGit

Export-ModuleMember -Alias * -Function *