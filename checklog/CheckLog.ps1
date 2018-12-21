Param(
    [string]$inFile
)

$mode = ""
$worktime = @{"始業"=0.0; "終業"=0.0; "休憩"=0.0}
$expect_total, $actual_total = 0.0, 0.0

Get-Content $inFile -Encoding UTF8 | foreach{
    $str = $_
    if($str -eq "---"){
        $worktime_total = $worktime["終業"]-$worktime["始業"]-$worktime["休憩"]-1.0
        Write-Host ("業務時間 = {0:0.00}h" -f $worktime_total)
        Write-Host ("今日のタスク（予定） = {0:0.00}h" -f $expect_total)
        Write-Host ("今日のタスク（実績） = {0:0.00}h" -f $actual_total)
        Write-Host
        exit
    }elseif($str -match "## (.*)"){
        $mode = $matches[1]
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
        if($str -match "- \[.\] (?<expect>[\d\.]+)h\s*/\s*(?<actual>[\d\.]+)h (?<title>.*)"){
            $expect = [double]$matches["expect"]
            $actual = [double]$matches["actual"]

            $expect_total += $expect
            $actual_total += $actual
        }
    }
}
