$inDir = "D:\shibata\note\current"
$outFile = "D:\shibata\tmp\日報.txt"

$today = (Get-Date).ToString("yyyyMMdd")
$inFile = "$inDir\$today.md"

$start = 9.5
$end = 17.5
$rest = 0.0

$expect_work_time = 0.0
$actual_work_time = 0.0

Get-Content $inFile -Encoding UTF8 | foreach{
    $str = $_
    if($str -match "\- 開始 (?<h>\d{2}):(?<m>\d{2})"){
        $start = [double]$matches["h"] + [double]$matches["m"] / 60.0
    }
    if($str -match "\- 終業 (?<h>\d{2}):(?<m>\d{2})"){
        $end = [double]$matches["h"] + [double]$matches["m"] / 60.0
    }
    if($str -match "\- 休憩 (?<h>\d{2}):(?<m>\d{2})"){
        $rest = [double]$matches["h"] + [double]$matches["m"] / 60.0
    }
    if($str -match "\t\- \[.\] (?<h>\d{2}):(?<m>\d{2})"){
        $expect_work_time += [double]$matches["h"] + [double]$matches["m"] / 60.0
    }
    if($str -match "\t\- \[.\] .{2}:.{2}\s*/\s*(?<h>\d{2}):(?<m>\d{2})"){
        $actual_work_time += [double]$matches["h"] + [double]$matches["m"] / 60.0
    }
}

Write-Host "業務時間：" ($end - $start - $rest - 1.0) "h"
Write-Host "今日のタスク（見積/実績）：" $expect_work_time "h / " $actual_work_time "h"
