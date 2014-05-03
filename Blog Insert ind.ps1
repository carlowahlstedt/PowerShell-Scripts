[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

#some temp variables if we want to update other lists later
$SharePointSite = "http://sharepointdev/"
$SharePointWeb = "discus"
$SharePointList = "Posts"
#where the file you're going to read data from to get the info is located
$workingdir="C:\Users\videos.txt"

#make the connection to sharepoint and to the list
$spSite = new-object Microsoft.SharePoint.SPSite($SharePointSite)
$spWeb = $spSite.OpenWeb($SharePointWeb)
$spList = $spWeb.Lists[$SharePointList]
$spItems = $spList.items



	$body = "<a href='/discuss/Videos/AreWeInAHiringFreeze.wmv'>Are we in a hiring freeze?</a>"

	$spListItem = $spList.AddItem()
	$spListItem["Title"] = "Are We In A Hiring Freeze"
	$spListItem["Category"] = 1
	$spListItem["Body"] = $body
	$spListItem["_ModerationStatus"] = 0
	$spListItem["Published"] = "1/19/2012 8:10:34 AM"
	$spListItem.Update()

	$body = "<a href='/discuss/Videos/BathroomTrashcans.wmv'>Can trash cans be placed within reach of the sink and doors in the restrooms so employees can help reduce illness?</a>"

	$spListItem = $spList.AddItem()
	$spListItem["Title"] = "Bathroom Trashcans"
	$spListItem["Category"] = 1
	$spListItem["Body"] = $body
	$spListItem["_ModerationStatus"] = 0
	$spListItem["Published"] = "1/19/2012 8:13:34 AM"
	$spListItem.Update()

	$body = "<a href='/discuss/Videos/EarlyCloseVacaTime.wmv'>When offices close early for holidays, are staff who are out for sick or vacation required to submit the full amount of time for their leave?</a>"

	$spListItem = $spList.AddItem()
	$spListItem["Title"] = "Early Close Vaca Time"
	$spListItem["Category"] = 3
	$spListItem["Body"] = $body
	$spListItem["_ModerationStatus"] = 0
	$spListItem["Published"] = "1/19/2012 8:14:36 AM"
	$spListItem.Update()

	$body = "<a href='/discuss/Videos/EmpMoraleUpdates.wmv'>Is there some way we can get updates on the suggestions made to Obama?</a>"

	$spListItem = $spList.AddItem()
	$spListItem["Title"] = "Emp Morale Updates"
	$spListItem["Category"] = 1
	$spListItem["Body"] = $body
	$spListItem["_ModerationStatus"] = 0
	$spListItem["Published"] = "1/19/2012 8:15:06 AM"
	$spListItem.Update()

	$body = "<a href='/discuss/Videos/LottoFund.wmv'>Does the Lottery still fund edu?</a>"

	$spListItem = $spList.AddItem()
	$spListItem["Title"] = "Lotto Fund"
	$spListItem["Category"] = 1
	$spListItem["Body"] = $body
	$spListItem["_ModerationStatus"] = 0
	$spListItem["Published"] = "1/19/2012 8:15:38 AM"
	$spListItem.Update()



$spSite.dispose()