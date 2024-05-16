Function Get-Something {
    <#
    .SYNOPSIS
        Retrieves information based on some information.
     
    .NOTES
        Name: Get-Something
        Author: Script Ranger
        Version: 1.0
        DateCreated: 2021.01.01
     
    .EXAMPLE
        Get-Something -SomethingToGet "SomeStringValue"
     
    .LINK
        https://github.com/YourRepositoryLinkHere
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [string[]] $SomethingToGet
    )

    BEGIN {
        $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

        $myRootPath = $PSScriptRoot
        $myFunctionName = $MyInvocation.MyCommand.Name

        Push-Location $myRootPath

        $logFile = Join-Path -Path "$myRootPath\_log" -ChildPath "$((Get-Date).ToString('yyyy.MM.dd.HHmmss')).$myFunctionName.log"
        # Change or Remove output file as needed
        $outputFile = Join-Path -Path "$myRootPath\_output" -ChildPath "$((Get-Date).ToString('yyyy.MM.dd.HHmmss')).$myFunctionName.csv"
        $configFile = "$myFunctionName.xml"

        Start-Transcript -Path $logFile

        if (Test-Path $configFile) {
            [xml]$settings = Get-Content $configFile
            # Process configuration settings if needed
            #example variable stored in the configuration file
            $environment = $settings.configuration.variables.Environment
        }

        # Load child function scripts.  This will bring all variables and objects into the same scope.
        Get-ChildItem -Path "$myRootPath\_function" -Filter "*.ps1" -Recurse -Verbose | ForEach-Object { . $_ }
    }

    PROCESS {
        # Implement processing logic here if needed
    }

    END {
        $stopWatch.Stop()
        Write-Output "$myFunctionName Completed"
        Write-Output $stopWatch.Elapsed
        Stop-Transcript
        Pop-Location
    }
}
