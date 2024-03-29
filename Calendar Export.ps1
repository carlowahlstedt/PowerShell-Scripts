[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

#some temp variables if we want to update other lists later
$SharePointSite = "http://sharepointdev/"
$SharePointWeb = "Departments/Appdev"
$SharePointList = "Calendar"

#make the connection to sharepoint and to the list
$spSite = new-object Microsoft.SharePoint.SPSite($SharePointSite)
$spWeb = $spSite.OpenWeb($SharePointWeb)
$spList = $spWeb.Lists[$SharePointList]

$query = New-Object Microsoft.SharePoint.SPQuery 
$query.query = "<Where><DateRangesOverlap><FieldRef Name='EventDate' /><FieldRef Name='EndDate' /><FieldRef Name='RecurrenceID' /><Value Type='DateTime'><Today /></Value></DateRangesOverlap></Where>"
$query.CalendarDate = Get-Date
$query.RecurrenceOrderBy = $true
$query.ExpandRecurrence = $true
$spItems = $spList.GetItems($query)

#write-host $spItems.Count

$emailBody = "Application Development Attendance<br /><br />"
#loop through all of the lists and update each one from the file we generated from SQL
foreach ($spItem in $spItems)
{
	#write-host $spItem["Title"] " - " $spItem["Start Time"] " - " $spItem["End Time"] " ed:" $spItem["EventDate"]
	#write-host $spItem["Recurrence"]
	#write-host "-----------------------------------"
	$emailBody += $spItem["Title"] + "<br />"
}

$spSite.Dispose()

$emailFrom = "cwahlstedt@gmail.org"
$emailTo = "cwahlstedt@gmail.org"
$emailCc = "dmorrison@gmail.org"
#$emailTo = "Attendance <Attendance@gmail.org>"
#$emailCc = "Application Development Department <ApplicationDevelopment@gmail.org>", "Network Support Department <NSDept@gmail.org>"
$emailSubject = "Application Development Attendance"
#$creds = Get-Credential 'NT AUTHORITY\ANONYMOUS LOGON'
send-mailmessage -from $emailFrom -to $emailTo -cc $emailCc -subject $emailSubject -body $emailBody -smtpServer mail.gmail.org -BodyAsHtml:$true -Credential $creds
