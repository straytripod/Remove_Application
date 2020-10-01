<#   
.SYNOPSIS   
    Uninstalls a native application through Powershell.

.DESCRIPTION 
    Presents an interactive menu for the user to declare the apllication to be removed. The program then check the regiserty for the application.
    The program then prompts the user with the application it found. On proceed the program check the application installer for MIS or EXE and 
    uses the proper uninstall process to remove the application.
.NOTES   
    Name: Remove App
    Author: StrayTripod
    Modifier: N/A
    DateCreated: September 30 2020
    DateModifed: 9/30/2020 
    Warning: Use this at you own risk! Make backups! Create snapshots! I am not responsible for any issues that arises due to the use of this program by anyone other then me.
         
.REFERNCE 
    None  
    
.DEPENDANCIES
   Powershell
#> 

$remapp = read-host "App name" 
$locateapp = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall  |
    Get-ItemProperty |
        Where-Object {$_.DisplayName -match "$remapp" } |
            Select-Object -Property DisplayName, UninstallString
write-host "FOUND:" $locateapp.DisplayName -foregroundColor red
write-host "Is this correct?"-foregroundColor cyan
$ans = read-host "[y / n]" 
if ($ans -eq "y") {
ForEach ($app in $locateapp) {

    If ($app.UninstallString) {
        if ($app.UninstallString -match "MsiExec.exe") 
        {
        write-host "perfoming uninstall of MSI application"-foregroundColor cyan
            get-package *$remapp* | uninstall-package 
        }else{
            $uninst = $ver.UninstallString
            write-host "perfoming uninstall of EXE application" -foregroundColor cyan
            # $uninst = $uninst.Replace('{',' ').Replace('}',' ')
            Start-Process -Argumentlist "/S" $uninst}
            }
}
}Else {Write-Host "Canceling Operation!"}
