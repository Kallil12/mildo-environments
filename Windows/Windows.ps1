function Set-ComputerName {
    param (
        [Parameter(Mandatory=$True)]
        [String]
        $NewComputerName
    )


    $ComputerSystem = Get-WmiObject -Class "Win32_ComputerSystem"
    $ComputerSystem.Rename($NewComputerName)
}


function Wait-MicrosoftAccount {
    $IsMicrosoftAccount = $False
    while (-not $IsMicrosoftAccount) {
        Start-Sleep -Milliseconds 1000
        $IsMicrosoftAccount = Get-LocalUser | Where-Object { $_.Enabled -match "True" -and $_.PrincipalSource -match "MicrosoftAccount" }
    }
}


function Set-RegionFormat {
    param (
        [Parameter(Mandatory=$True)]
        [String]
        $NewCulture
    )


    Set-Culture -CultureInfo $NewCulture
}


function Disable-PagingFile {
    $ComputerSystem = Get-WmiObject -Class "Win32_ComputerSystem"
    $ComputerSystem.AutomaticManagedPagefile = $False
    $ComputerSystem.Put()

    Get-WmiObject -Class "Win32_PageFileSetting" | % Delete
}


function Activate-Windows {
    param (
        [Parameter(Mandatory=$True)]
        [String]
        $KmsServer
    )


    Slmgr -Skms $KmsServer
    Slmgr -Ato
}


function Add-HyperV {
    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName "Microsoft-Hyper-V" -All
}


function Update-Windows {
    (New-Object -ComObject "Microsoft.Update.AutoUpdate").DetectNow()
}


function Add-CustomScheduledJob {
    $Trigger = New-JobTrigger -AtLogon
    $Options = New-ScheduledJobOption -RequireNetwork -StartIfOnBattery -ContinueIfGoingOnBattery
    $Principal = New-ScheduledTaskPrincipal -LogonType Interactive -UserId $Env:Username -RunLevel Highest
    $Commands = {
        Import-Module -Name "PSWorkflow"
        Resume-Job -Name "Configure-Windows-Job" | Wait-Job
    }

    Register-ScheduledJob -Name "Resume-Configure-Windows-Job" -Trigger $Trigger -ScheduledJobOption $Options -ScriptBlock $Commands
    Set-ScheduledTask -TaskName "Resume-Configure-Windows-Job" -Principal $Principal -TaskPath "\Microsoft\Windows\PowerShell\ScheduledJobs\"
}


workflow Configure-Windows {
    Set-ComputerName -NewComputerName "Mildo-Note-Wind"

    Restart-Computer
    Suspend-Workflow
    Wait-MicrosoftAccount

    Set-RegionFormat -NewCulture "pt-BR"
    Disable-PagingFile
    Activate-Windows -KmsServer "kms.digiboy.ir"
    Add-HyperV
    Update-Windows

    Unregister-ScheduledJob -Name "Resume-Configure-Windows-Job"
}


Add-CustomScheduledJob
Configure-Windows -AsJob -JobName "Configure-Windows-Job"
