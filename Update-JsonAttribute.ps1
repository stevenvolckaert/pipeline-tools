#Requires -Version 3

<#
.SYNOPSIS
    Updates a single attribute of a specified JSON file.
.DESCRIPTION
    This cmdlet updates a single attribute of a specified JSON file with the provided value. If the attribute does not
    exist, the cmdlet will add it automatically. In addition, all single- and multi-line comments are removed.
.NOTES
    File Name       : Update-JsonAttribute.ps1
    Author          : Steven Volckaert (steven.volckaert@gmail.com)
    Prerequisites   : PowerShell version 3
.LINK
    https://dev.azure.com/skarabeecomnv/Tools/_git/pipeline-tools
.EXAMPLE
    .\Update-JsonAttribute.ps1 "$Env:BUILD_SOURCESDIRECTORY\src\Kdc.DocumentSigningService\appsettings.json" -Attribute BuildNumber -Value "$Env:BUILD_BUILDNUMBER"
#>

Param (
    [string] $JsonFile = $(throw "Argument -JsonFile is required"),
    [string] $Attribute = $(throw "Argument -Attribute is required"),
    [string] $Value = $(throw "Argument -Value is required") 
)

# FUNCTIONS ##########################################################################################################

<#
.SYNOPSIS
    Formats JSON in a visually more pleasing format than the built-in ConvertTo-Json cmdlet.
#>
function Format-Json {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Json
    )

    $indent = 0;
    
    ($Json -Split '\n' |
        ForEach-Object {
            if ($_ -match '[\}\]]') {
                # This line contains  ] or }; decrement indentation level
                $indent--;
            }
            $line = (' ' * $indent * 2) + $_.TrimStart().Replace(':  ', ': ')
            if ($_ -match '[\{\[]') {
                # This line contains [ or {; increment indentation level
                $indent++;
            }
            $line
        }) -Join "`n";
}

<#
.SYNOPSIS
    Removes all single-line and multi-line comments from a JSON-formatted string.
#>
function Remove-JsonComments {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Json
    )
    $Json -replace '//.*|/\*[\s\S]*?\*/|("(\\.|[^"])*")','$1'
}

# MAIN ###############################################################################################################

if ((Test-Path "$JsonFile") -eq $False) {
    Write-Error "Abort: File '$JsonFile' does not exist.";
    exit 1;
}

$JsonObject = Get-Content $JsonFile -Raw | Remove-JsonComments | ConvertFrom-Json;
Write-Host "Overwriting attribute '$Attribute' of '$JsonFile' with '$Value'.";
$JsonObject | Add-Member -Force -MemberType NoteProperty -Name $Attribute -Value $Value;
$JsonObject | ConvertTo-Json -Depth 100 | Format-Json | Set-Content $JsonFile
