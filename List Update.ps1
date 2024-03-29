[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

#some temp variables if we want to update other lists later
$SharePointSite = "http://sharepointdev/"
$SharePointWeb = "Collaboration"
$SharePointList = "discuss"
#where the file you're going to read data from to get the info is located
$workingdir="C:\Users\videos.txt"

#make the connection to sharepoint and to the list
$spSite = new-object Microsoft.SharePoint.SPSite($SharePointSite)
$spWeb = $spSite.OpenWeb($SharePointWeb)
$spList = $spWeb.Lists[$SharePointList]
$spItems = $spList.items | Sort -Property Name

#import a csv file with a tab delimiter
$lines = Import-Csv -Path $workingdir -Delimiter `t

$getLine = 0
#loop through all of the lists and update each one from the file we generated from SQL
foreach ($spItem in $spItems)
{
    $line = $lines[$getLine]

    if($spItem["Name"] -eq $line.name + ".wmv")
    {
        $spItem["Title"] = $line.title
        $spItem["Category"] = $line.category
        $spItem["Scheduling Start Date"] = $line.date

        #write-host $line.name
        #write-host $spItem["Title"]
        #write-host $spItem["Category"]
        #write-host $spItem["Scheduling Start Date"]
        #write-host "-----------------------------------"
        $spItem.Update()
        write-host $getLine
    }
    else
    {
        write-host "Failed to update because name didn't match:"
        write-host "name from file: " + $line.name
        write-host "name from sp: " + $spItem["Name"]
        write-host "line: " + $getLine
        write-host "-----------------------------------"
    }
    $getLine++;
}
