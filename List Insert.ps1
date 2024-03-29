[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

#some temp variables if we want to update other lists later
$SharePointSite = "http://sharepointdev/"
$SharePointWeb = "Collaboration"
$SharePointList = "Discussion"
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
#loop through all of the line and insert a new item
foreach ($line in $lines)
{
	$spListItem = $spList.AddItem()
	$spListItem["Subject"] = $line.name
	$spListItem["Body"] = $line.title 
	$spListItem["Last Updated"] = $line.date
	$spListItem.Update()

	write-host $getLine
	
    $getLine++;
}
