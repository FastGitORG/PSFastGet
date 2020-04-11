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
        $Url: GitHub url
    .Outputs
        return: FastGit url
    .Notes
        The script is built by FastGit member(@KevinZonda)
#>
    param (
        [Parameter(Mandatory=$True)]
        [string]$Url
    )
    # $Url
    if ($Url.StartsWith("https://github.com")) {
        $_SplitUrl = $Url.Replace("https://github.com/", "").Split('/');
        if(($_SplitUrl[2].ToLower() -eq "raw") -or  ($_SplitUrl[2].ToLower() -eq "blob")) {
            # Convert to RAW
            $_Result = "https://raw.fastgit.org/";
            for ($i = 0; $i -lt $_SplitUrl.Length; ++$i){
                if($i -ne 2) {
                    $_Result += $_SplitUrl[$i] + "/"
                }
            }
            return $_Result.Substring(0, $_Result.Length - 1)
        }
        elseif($_SplitUrl[2].ToLower() -eq "releases") {
            # Convert to Release
            return $Url.Replace("https://github.com", "https://release.fastgit.org")
        }
        elseif($_SplitUrl[2].ToLower() -eq "archive") {
            # Convert to codeload
            # TODO: CODELOAD PROXY
            $_Result = "https://codeload.github.com/";
            for ($i = 0; $i -lt $_SplitUrl.Length; ++$i){
                if($i -ne 2) {
                    $_Result += $_SplitUrl[$i] + "/"
                }
            }
            return $_Result.Substring(0, $_Result.Length - 1)
        }
        else {
            return $Url
        }
    }
    elseif ($Url.StartsWith("https://raw.githubusercontent.com/")) {
        return $Url.Replace("https://raw.githubusercontent.com/", "https://raw.fastgit.org/")
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
        Get-FastGit -Url "https://github.com/KevinZonda/Widget-WPF/releases/download/1.0.0/Widget-WPF-1.0.0-Installer.zip"
        This will download file with FastGit url of https://github.com/dotnet/installer/archive/v3.1.201.zip
    .Inputs
        $Url: GitHub url
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
    if($_SplitUrl.Length -eq 0) {
        throw "$Url is invalid."
    } 

    $filename = $_SplitUrl[$_SplitUrl.Length - 1];

    if($OutFile) {
        if($OutFile.EndsWith("\\") -or $OutFile.EndsWith("/")) {
            $OutFile += $filename
        }
    }
    else
    {
        $OutFile = $filename
    }

    Invoke-WebRequest -Uri $Url -OutFile $OutFile
}

#function Get-FastGit($Url, $OutFile) {

#    
#}
#
# Test
#
#ConvertTo-FastGitUrl -url "https://github.com/KevinZonda/Widget-WPF/releases/download/1.0.0/Widget-WPF-1.0.0-Installer.zip"
#ConvertTo-FastGitUrl -url "https://github.com/KevinZonda/BullshitGenerator.Android/blob/master/README.md"
#ConvertTo-FastGitUrl -url "https://github.com/KevinZonda/BullshitGenerator.Android/raw/master/README.md"
#ConvertTo-FastGitUrl -url "https://github.com/dotnet/installer/archive/v3.1.201.zip"
#ConvertTo-FastGitUrl
#Get-FastGit -Url "https://github.com/KevinZonda/Widget-WPF/releases/download/1.0.0/Widget-WPF-1.0.0-Installer.zip"
#help  ConvertTo-FastGitUrl -Full