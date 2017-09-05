Param(
    [string]$inFile,
    [string]$outFile
)

$mode = ""
$output = @()
$worktime = @{"始業"=0.0; "終業"=0.0; "休憩"=0.0}
$expect_total, $actual_total = 0.0, 0.0

Get-Content $inFile -Encoding UTF8 | foreach{
    $str = $_
    if($str -eq "----"){
	$worktime_total = $worktime["終業"]-$worktime["始業"]-$worktime["休憩"]-1.0
	$output += ("[業務時間/予定/実績 = {0:0.00}h/{1:0.00}h/{2:0.00}h]" -f $worktime_total, $expect_total, $actual_total)
	([string]::Join("`n", $output)) | Out-File $outFile -Encoding UTF8
        exit
    }elseif($str -eq "# 日報"){
    }elseif($str -match "## (.*)"){
        $mode = $matches[1]
        $output += $str
    }elseif($mode -eq "業務時間"){
        if($str -match "\- (?<key>.*) (?<value>\d{2}:\d{2})"){
            $key = $matches["key"]
            $value = $matches["value"]
            $ts = $value -split ":"
	    $t = [double](60*[int]$ts[0]+[int]$ts[1])/60.0
	    $worktime[$key] = $t
        }
        $output += $str
    }elseif($mode -eq "今日のタスク（予定/実績）"){
        if($str -match "- \[.\] p(?<expect>\d+)/p(?<actual>\d+) (?<title>.*)"){
	    $expect = [double]$matches["expect"]*0.5
	    $actual = [double]$matches["actual"]*0.5
	    $title = $matches["title"]
	    $output += ("`t- {0} 【{1:0.00}h/{2:0.00}h】" -f $title, $expect, $actual)

	    $expect_total += $expect
	    $actual_total += $actual
        }else{
            $str = $str -replace "\[.\] ", ""
            $output += $str
	}
    }elseif($mode -eq "明日以降のタスク"){
        $str = $str -replace "\[.\] ", ""
        $output += $str
    }else{
        $output += $str
    }
}
