#Requires -Version 1

<#
.SYNOPSIS
    Writes all environment variables, one per line, to the default host.
.DESCRIPTION
.NOTES
    File Name       : Write-EnvironmentVariables.ps1
    Author          : Steven Volckaert (steven.volckaert@gmail.com)
    Prerequisites   : PowerShell version 1
.LINK
    https://dev.azure.com/skarabeecomnv/Tools/_git/pipeline-tools
.EXAMPLE
    .\Write-EnvironmentVariables.ps1
#>

# Param (
#     [string] $Arg1 = $(throw "Argument -Arg1 is required"),
#     [string] $Arg2 = $(throw "Argument -Arg2 is required")
# )

# FUNCTIONS ###########################################################################################################

<#
.SYNOPSIS
    Returns all environment variables, ordered alphabetically by name.
#>
function Get-EnvironmentVariables {
    (Get-ChildItem env:*).GetEnumerator() | Sort-Object Name;
}

# MAIN ################################################################################################################

Get-EnvironmentVariables | ForEach-Object { "   {0,-36} = {1,-36}" -f $_.Name, $_.Value } | Write-Host;
