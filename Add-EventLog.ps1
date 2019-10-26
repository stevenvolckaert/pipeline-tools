#Requires -Version 1

<#
.SYNOPSIS
    Creates a new event log on the local computer if it doesn't exist.
.DESCRIPTION
    This cmdlet creates a new event log on the local computer, if an event log with the specified source name doesn't
    exist. If it does, this cmdlet does nothing. By default, the event log is given the log name "Application", which
    can be overridden with the -LogName parameter.
.NOTES
    File Name       : Add-EventLog.ps1
    Author          : Steven Volckaert (steven.volckaert@gmail.com)
    Prerequisites   : PowerShell version 1
.LINK
    https://dev.azure.com/skarabeecomnv/Tools/_git/pipeline-tools
.EXAMPLE
    .\Add-EventLog.ps1 "$env:EVENTLOGSOURCENAME"
#>

Param (
    [string] $SourceName = $(throw "Argument -SourceName is required"),
    [string] $LogName = "Application"
)

# FUNCTIONS ##########################################################################################################

# MAIN ###############################################################################################################

if ([System.Diagnostics.EventLog]::SourceExists($SourceName) -eq $false) {
    Write-Host -NoNewline "Event log '$SourceName' does not exist. Creating...";
    New-EventLog -LogName $LogName -Source "$SourceName";
    Write-Host " OK";
}
else {
    Write-Host "Event log '$SourceName' already exists." 
}
