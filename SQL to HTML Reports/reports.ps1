$date = Get-Date -format "MM-dd-yyyy"
# SQL instance name
#$dataSource = "SQLServer"
# Database name    	
$database = "DatabaseName"
# The title of the HTML page
$TableHeader = "$date"
# The file location
$OutputFile = "C:\files\Powershell\Reports\" + $date + ".html"

# set HTML formatting
$a = @"
<style>
BODY {
    background-color:white;
    width:95%;
    text-align:center; /* IE */
    margin:0 auto; /* Other Browsers */
}
TABLE {
    border-width: 1px;
    border-style: solid;
    border-color: black;
    border-collapse: collapse;
    width:100%;
}
TH {
    border-width: 1px;
    padding: 0px;
    border-style: solid;
    border-color: black;
    background-color:#C0C0C0;
}
TD {
    border-width: 1px;
    padding: 0px;
    border-style: solid;
    border-color: black;
    background-color:white;
    text-align:center;
}
tr:nth-child(odd) td { background-color: #E2E2E2; }
tr:hover td { background-color: #2BD5FF; }
p {
    font-size:18px;
    family:calibri;
    color:#325BFF;
    text-align:left;
}
#dateTitle {
	background:#666;
	border-bottom: #666 solid;
	border-top: #666 solid;
	border-width: 1px;
	font-size:20px;
	family:calibri;
	color:#ffffff;
	text-align:center;
}
#serverTitle {
	background:#ff9100;
	border-top: #666 solid;
	border-left: #666 solid;
	border-right: #666 solid;
	border-width: 1px;
	font-size:12px;
	family:calibri;
	color:#000;
	text-align:center;
}
</style>
"@

$body = @"
<div id="dateTitle">$TableHeader</div>
"@


#make the server titles
$htmlServ1Title = @"
<div id="serverTitle">Server 1</div>
"@


#First do Server 
$dataSource = "Server"

# Create a string variable with all our connection details 
$connectionDetails = "Provider=sqloledb; Data Source=$dataSource; Initial Catalog=$database; Integrated Security=SSPI;"

# Connect to the data source using the connection details and T-SQL command we provided above, and open the connection
$connection = New-Object System.Data.OleDb.OleDbConnection $connectionDetails
$connection.Open()

# Get the results of our Total sql command into a DataSet object
$cmdTotal = [System.IO.File]::ReadAllText("C:\files\SQL\Total.sql")
$cmd = New-Object System.Data.OleDb.OleDbCommand $cmdTotal,$connection
$dataAdapter = New-Object System.Data.OleDb.OleDbDataAdapter $cmd
$dsTotalTime = New-Object System.Data.DataSet
$dataAdapter.Fill($dsTotalTime)

# Get the results of our Total sql command into a DataSet object
$cmdTotal = [System.IO.File]::ReadAllText("C:\files\SQL\Greater Than Minute.sql")
$cmd = New-Object System.Data.OleDb.OleDbCommand $cmdTotal,$connection
$dataAdapter = New-Object System.Data.OleDb.OleDbDataAdapter $cmd
$dsGreater = New-Object System.Data.DataSet
$dataAdapter.Fill($dsGreater)

# Get the results of our Total sql command into a DataSet object
$cmdErrorCount = [System.IO.File]::ReadAllText("C:\files\Error Count.sql")
$cmd = New-Object System.Data.OleDb.OleDbCommand $cmdErrorCount,$connection
$dataAdapter = New-Object System.Data.OleDb.OleDbDataAdapter $cmd
$dsErrorCount = New-Object System.Data.DataSet
$dataAdapter.Fill($dsErrorCount)

# Get the results of our Total sql command into a DataSet object
$cmdErrorMessages = [System.IO.File]::ReadAllText("C:\files\Error Messages.sql")
$cmd = New-Object System.Data.OleDb.OleDbCommand $cmdErrorMessages,$connection
$dataAdapter = New-Object System.Data.OleDb.OleDbDataAdapter $cmd
$dsErrorMessages = New-Object System.Data.DataSet
$dataAdapter.Fill($dsErrorMessages)

# Get the results of our Total sql command into a DataSet object
$cmdErrorItems = [System.IO.File]::ReadAllText("C:\files\Error Items.sql")
$cmd = New-Object System.Data.OleDb.OleDbCommand $cmdErrorItems,$connection
$dataAdapter = New-Object System.Data.OleDb.OleDbDataAdapter $cmd
$dsErrorItems = New-Object System.Data.DataSet
$dataAdapter.Fill($dsErrorItems)

# Close the connection
$connection.Close()

# Get the html for each of the tables and add headers
$htmlServTotal = $htmlServTitle + ($dsTotalTime.Tables | Select-Object -Expand Rows | ConvertTo-HTML "Column2","Column3" -Fragment)
$htmlServPer = $htmlServTitle + ($dsGreater.Tables | Select-Object -Expand Rows | ConvertTo-HTML "Column4","Column3", "Column1" -Fragment)
$htmlServErrorCount = $htmlServTitle + ($dsErrorCount.Tables | Select-Object -Expand Rows | ConvertTo-HTML "Column1","Column5" -Fragment)
$htmlServErrorMessages = $htmlServTitle + ($dsErrorMessages.Tables | Select-Object -Expand Rows | ConvertTo-HTML "Column" -Fragment)
$htmlServErrorItems = $htmlServTitle + ($dsErrorItems.Tables | Select-Object -Expand Rows | ConvertTo-HTML "Column" -Fragment)


#make the headers
$headerTotal = @"
<p>Total Times</p>
"@
$headerGreater = @"
<p>Greater Than 1 Minute</p>
"@
$headerErrorCount = @"
<p>Error Count</p>
"@
$headerErrorMessages = @"
<p>Error Messages</p>
"@
$headerErrorItems = @"
<p>Error Items</p>
"@

#put the groups together
$htmlTotal = $headerTotal + $htmlServTotal  
$htmlGreater = $headerGreater + $htmlServGreater 
$htmlErrorCount = $headerErrorCount + $htmlServErrorCount 
$htmlErrorMessages = $headerErrorMessages + $htmlServErrorMessages 
$htmlErrorItems = $headerErrorItems + $htmlServErrorItems 

#put all html together
$html = $htmlTotal + $htmlGreater + $htmlErrorCount + $htmlErrorMessages + $htmlErrorItems 

# add it all together and the output to file
ConvertTo-HTML -head $a –body "$body $html" | Out-File $OutputFile

#make the default page again now that we've made a new report page
. "C:\files\Powershell\default.ps1"
MakeDefault
