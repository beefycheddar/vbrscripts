<# 
   .Synopsis 
    Enables creation of subfolders by VM name when performing IVR from VMware to Hyper-V on multiple VMs simultaneously.
   .Example 
	Execute on VBR server locally (run with Administrator privileges): 
        .\IVR2HV_w_VM_Folders.ps1
    Execute from remote server (run with Administrator privileges): 
        Invoke-Command -FilePath <PATH_TO_THIS_SCRIPT> -ComputerName <GUEST_OS_SERVERNAME> -Credentials (Get-Credential)
   .Notes 
    NAME: IVR2HV_w_VM_Folders.ps1
    AUTHOR: ChatGPT for Brett Gavin, Veeam Software
    CONTACT: brett.gavin@veeam.com
    LASTEDIT: 3-26-2024
    KEYWORDS: Hyper-V, Instant VM Restore, VM Subfolders
    
    In this script:

	$sourceVMs retrieves the VMs from the Veeam backup job.
	$targetHyperVHost and $targetHyperVDatastore specify the Hyper-V host and datastore where the VMs will be restored.
	Inside the foreach loop, $vm.Name is used to get the name of each VM being restored.
	$folderName specifies the name of the subfolder for each VM. You can modify this to include any naming convention you prefer.
	Start-VBRVMRestoreToHyperV initiates the restore operation for each VM, specifying the target Hyper-V host, datastore, and the folder where the VM should be restored.
	By using this approach, you can create a subfolder for each VM being restored during the migration from VMware to Hyper-V, helping to organize the restored VMs for better management and identification.

#> 


# Connect to Veeam Backup Server
Connect-VBRServer -Server "YourVeeamServer"

# Define source and destination parameters
$sourceVMs = Get-VBRBackup -Name "YourBackupJobName"
$targetHyperVHost = Get-VBRServer -Name "YourHyperVHost"
$targetHyperVDatastore = Get-VBRServer -Name "YourHyperVDatastore"

# Perform restore operation for each VM in the backup
foreach ($vm in $sourceVMs.VMs) {
    $vmName = $vm.Name
    $folderName = "Subfolder_$vmName" # Modify as needed to suit your naming convention

    # Restore VM to Hyper-V with a subfolder for each VM
    Start-VBRVMRestoreToHyperV -Server $targetHyperVHost -Backup $vm -Datastore $targetHyperVDatastore -Folder $folderName
}
