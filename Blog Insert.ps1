[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

#some temp variables if we want to update other lists later
$SharePointSite = "http://sharepointdev/"
$SharePointWeb = "discuss"
$SharePointList = "Posts"
#where the file you're going to read data from to get the info is located
$workingdir="C:\Users\videos.txt"

#make the connection to sharepoint and to the list
$spSite = new-object Microsoft.SharePoint.SPSite($SharePointSite)
$spWeb = $spSite.OpenWeb($SharePointWeb)
$spList = $spWeb.Lists[$SharePointList]
$spItems = $spList.items

#import a csv file with a tab delimiter and sort by date
$lines = Import-Csv -Path $workingdir -Delimiter `t | Sort-Object -Property {[datetime] $_.date}

$getLine = 0
#loop through all of the line and insert a new item
foreach ($line in $lines)
{
	$body = "<a href='/discuss/Videos/"+$line.filename+".wmv'>"+$line.title+"</a>"

	$spListItem = $spList.AddItem()
	$spListItem["Title"] = $line.name
	switch ($line.category)
	{
		"General" {	$spListItem["Category"] = 1 }
		"Employee Benefits" { $spListItem["Category"] = 2 }
		"Financial" { $spListItem["Category"] = 3 }
		"Off the Wall" { $spListItem["Category"] = 4 }
	}
	$spListItem["Body"] = $body
	$spListItem["_ModerationStatus"] = 0
	$spListItem["Published"] = $line.date
	$spListItem.Update()

	write-host $getLine
	write-host $body
	
    $getLine++;
}

$spSite.dispose()