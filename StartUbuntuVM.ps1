
# Description: Initiates a VM hosted on VirtualBox and makes an SSH conncetion to it with Putty

# Prerequisites:
#
# 1. VBoxManage must be installed - make sure that VBOX_MSI_INSTALL_PATH exists in your environment
# 2. Putty must be installed
# 3. SSH to VM must be possible manually - preferably use NAT & portforwarding in order to use the "Ethernet adapter VirtualBox Host-Only Network" IP


get-content variables.env | foreach {
    $name, $value = $_.split('=')
    set-content env:\$name $value
}

$Env:PATH += ";$env:VBOX_MSI_INSTALL_PATH"
if (vboxmanage showvminfo "$VMName" | select-string -Pattern 'running ') 
{
    Write-Host "Mate, your VM is already running, i 'll try to connect"
}
else
{
    #Start-Process -Filepath "vboxmanage.exe" -ArgumentList "startvm `"$VMName`""
    vboxmanage startvm $VMName
    Start-Sleep -Milliseconds 100
    if (-not(vboxmanage showvminfo "$VMName" | select-string -Pattern 'running ')) 
    {
        Write-Host -Message "Something went wrong ...sorry" 
        exit   
    }
    else
    {
        Start-Sleep -Milliseconds 60000
    }

}

Start-Process -Filepath "$PuttyPath\putty.exe" -ArgumentList " -ssh $VMUser@$VM_IP -pw $VMPass "