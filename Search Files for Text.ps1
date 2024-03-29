$outFile = "Z:\PowerShell\FileSearch\results.sql"
$workingFile = "Z:\PowerShell\FileSearch\file.txt"
$codePath = "C:\Projects\*"

$fileContents = get-content $workingFile
$count = $fileContents | Measure-Object
$counter = 1
$sqlDrop = ""

$startTime = Get-Date
foreach ($storedProcedure in $fileContents)
{
    $results = Get-Childitem $codePath -recurse | SELECT-STRING -pattern $storedProcedure -List

    if($results -eq $null)
    {
        $sqlDrop += "DROP PROCEDURE [" + $storedProcedure + "]`n"
        #write-host $sqlDrop 
    }
    
    write-host $counter " of " $count.count
    $counter++
}
$endTime = Get-Date

#DROP PROCEDURE [NextAvailableBatchID_cod]
#DROP PROCEDURE [UpdateBuildingPlacedInServiceDate_mod]
#DROP PROCEDURE [ParsePhoneNumber]
#DROP PROCEDURE [EmailAddresses_mod]
#DROP PROCEDURE [MonitoringGridAnswer_mod]
#DROP PROCEDURE [BatchIntegrationData_CreateVendorID_cod]

$sqlDrop += "/*`n"
$sqlDrop += "* Start Time: " + $startTime + "`n"
$sqlDrop += "* End Time: " + $endTime + "`n"
$sqlDrop += "* Total Time: " + ($endTime - $startTime) + "`n*/"
$sqlDrop | Out-File $outFile
