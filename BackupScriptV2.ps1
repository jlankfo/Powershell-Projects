#Date for backup name
$date = Get-Date -UFormat "%m%d%Y"
$backupName = $date

#From path X to path Y
#$fromPath = "C:\Program Files (x86)\Battle.net"
$toPath = "C:\Users\usdaj\Desktop\$backupName"

#Ask script user what directory they would like to backup recursivly
$fromPath = Read-Host -Prompt "What directory would you like to backup?"

#Ask script user to start if they would like to start the backup
Write-Output "Would you like to start backing up files?"
$answer = Read-Host -Prompt "Y or N"

#Get number of files that will be moving to verify all files were backed up
$numberOfFilesToMove = @(Get-ChildItem -Path $fromPath).Count

<#Logic - If input is validated the script will copy all items in Folder X to Folder Y 
and display how many files have moved and how many are remaining #>
if ($answer -eq "Y" -or $answer -eq "y") {
    New-Item -ItemType "directory" -Path $toPath -Name $backupName
    Write-Output "`nNumber of files and folders to move: $numberOfFilesToMove `n"
    foreach ($file in Get-ChildItem -Path $fromPath){
        $filesMoved = @(Get-ChildItem -Path $toPath).Count
        Copy-Item $file.FullName -Destination $toPath -Recurse
        Write-Output "Number of files and folders moved: $filesMoved"
        if($filesMoved -eq $numberOfFilesToMove){
            Write-Output "All files moved, backup completed successfully."
        }
        $filesMoved -= 1
    }
    Remove-Item $toPath\$backupName
    Write-Output "Starting compression..."
    
#Compress archive    
    Compress-Archive -Path $toPath -DestinationPath $toPath
#Remove uncompressed archive
    Remove-Item -LiteralPath $toPath -Force -Recurse
    Write-Output "Compression complete!"
}
elseif ($answer -eq "N" -or $answer -eq "n") {
    Write-Output "Exiting script..."
    Exit
}
else {
    "Sorry, input not valid, exiting..."
    Exit
}