#Requires -Version 1

<#
.SYNOPSIS
    Updates the build number of an Azure Pipelines build.
.DESCRIPTION
    This cmdlet updates the build number of an Azure Pipelines build. It does so by 
.PARAMETER BuildNumber
    The build number to use.
.PARAMETER SourceBranch
    The source branch to use.
.PARAMETER SourceVersion
    The source version, i.e. the commit has, to use.
.PARAMETER AddSourceBranchName
    A value that indicates whether to add the source branch name to the build number.
.NOTES
    File Name       : Update-BuildNumber.ps1
    Author          : Steven Volckaert (steven.volckaert@gmail.com)
    Prerequisites   : PowerShell version 1
.LINK
    https://dev.azure.com/skarabeecomnv/Tools/_git/pipeline-tools
.EXAMPLE
    .\Update-BuildNumber.ps1 "$env:BUILD_BUILDNUMBER" -SourceBranch "$env:BUILD_SOURCEBRANCH" -SourceVersion "$env:BUILD_SOURCEVERSION"
    .\Update-BuildNumber.ps1 "$env:BUILD_BUILDNUMBER" -SourceBranch "$env:BUILD_SOURCEBRANCH" -AddSourceBranchName -SourceVersion "$env:BUILD_SOURCEVERSION"
#>

Param (
    [string] $BuildNumber = $env:BUILD_BUILDNUMBER,
    [string] $SourceBranch = $env:BUILD_SOURCEBRANCH,
    [string] $SourceVersion = $env:BUILD_SOURCEVERSION,
    [switch] $AddSourceBranchName = $False
)

if (!$BuildNumber) {
    throw "Environment variable 'BUILD_BUILDNUMBER' does not exist: Argument -BuildNumber is required" 
}

if (!$SourceBranch) {
    throw "Environment variable 'BUILD_SOURCEBRANCH' does not exist: Argument -SourceBranch is required" 
}

if (!$SourceVersion) {
    throw "Environment variable 'BUILD_SOURCEVERSION' does not exist: Argument -SourceVersion is required" 
}

# FUNCTIONS ###########################################################################################################

# MAIN ################################################################################################################

$ShortSourceVersion = $SourceVersion.Substring(0, 8);
$NewBuildNumber = "$BuildNumber-$ShortSourceVersion"

if ($AddSourceBranchName -or $SourceBranch.StartsWith("refs/tags/")) {
    $SourceBranchName = $SourceBranch.split("/")[-1];
    $NewBuildNumber = "$NewBuildNumber-$SourceBranchName";
}

if ($BuildNumber.Contains($ShortSourceVersion)) {
    Write-Host "Abort: Build number '$BuildNumber' has already been updated by another pipeline job.";
}
else {
    Write-Host "##vso[build.updatebuildnumber]$NewBuildNumber";
}
