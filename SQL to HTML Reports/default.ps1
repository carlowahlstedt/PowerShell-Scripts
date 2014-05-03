function MakeDefault() {
$date = Get-Date -format "MM-dd-yyyy"
# The title of the HTML page
$TableHeader = "SQL Report"
# The file location
$OutputFile = "C:\files\Powershell\default.html"
# path
$path = "C:\files\Powershell\Reports"

# set HTML formatting
$a = @"
<style>
BODY {
    background-color:white;
    width:90%;
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
#main {
    position:relative;
}
#frame {
    position:absolute;
    border-style:solid;
    border-width:1px;
    top:0px;
    left:150px;
    margin-left:0px;
    width:90%;
    height:810px;
    background:white;
}
#navigation {
    position:absolute;
    width:200px;
    margin-left:-50px;
    height:100%;
	font-size:0.75em;
}
#navigation ul {
	margin:0px;
	padding:0px;
}
#navigation a {
	color: #fff;
	cursor: pointer;
	display:block;
	height:25px;
    font-size:13px;
	line-height: 25px;
	text-indent: 10px;
	text-decoration:none;
	width:100%;
}
#navigation a:hover{
	text-decoration:underline;
	color: #ff9100;
	background:#444444;
}
#navigation li {list-style: none;} 
ul.top-level { background:#666; }
ul.top-level li {
	border-bottom: #fff solid;
	border-top: #fff solid;
	border-width: 1px;
}
#pageHeader {
    font-size:25px;
    family:calibri;
    color:#ff9100;
    text-align:center;
}
</style>
<style type="text/javascript">
    var iframe = document.getElementById("iframe_id").src;
    var menu = document.getElementById('toplevel').getElementsByTagName('a');
    for (var i = 0, len = menu.length; i < len; i++ ) {
    	if (iframe == menu[i].href) {
    		document.getElementById('toplevel').getElementsByTagName('li')[i].style.background = '#444444';
    	}
    }
</style>

<p id="pageHeader">SQL Report</p>
"@

$html = @"
<div id="main">
    <div id="navigation">
        <ul id="nav" class="top-level">
"@

$files = Get-ChildItem -Path $path

for ($i=0; $i -lt 30; $i++) {
if ($i -lt $files.count) {
$file = $files[$files.count-$i-1]
$linkName = [string]$files[$files.count-$i-1]
$linkName = $linkName.Replace(".html", "")
$html += @"
<li><a href="./Reports/$file" target="main">$linkName</a></li>
"@
}
}

$html += @"
        </ul>
    </div>
    <div id="frame">
"@

$currentReport = $files[$files.count-1]

$html += @"
<iframe name="main" src="./Reports/$currentReport" width="100%" height="810px" frameborder="0" />
"@
$html += "        
    </div>
</div>
"

# add it all together and the output to file
ConvertTo-HTML -head $a –body "$html" | Out-File $OutputFile
}

