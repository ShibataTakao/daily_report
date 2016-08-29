$inDir = "D:\shibata\note\current"
$outFile = "D:\shibata\tmp\日報.md"

$today = (Get-Date).ToString("yyyyMMdd")
$inFile = "$inDir\$today.md"

$mode = ""
$time = @{}
$category = @{}
$output = @()
$worktime = @{"始業"="09:30"; "終業"="17:30"; "休憩"="00:00"}

Get-Content $inFile -Encoding UTF8 | foreach{
    # $str = $_.Replace("`t","  ")
    $str = $_
    if($str -eq "----"){
        ([string]::Join("`n", $output)) | Out-File $outFile -Encoding UTF8
        exit
    }elseif($str -eq "# 日報"){
    }elseif($str -match "## (.*)"){
        if($mode -eq "活動記録"){
            $total = 0
            foreach($cat in ($category.Keys | sort)){
                $output += "- $cat"
                foreach($title in $category[$cat]){
                    if($time[$title][0] -eq 0){
                        $expect_time = " - "
                    }else{
                        $expect_time = "{0:0.00}h" -f $time[$title][0]
                    }
                    if($time[$title][1] -eq 0){
                        $actual_time = " - "
                    }else{
                        $actual_time = "{0:0.00}h" -f $time[$title][1]
                    }
                    $total += $time[$title][1]
                    $output += ("`t- {0} 【{1}/{2}】" -f $title, $expect_time, $actual_time)
                }
            }
            $output += ("[total:{0:0.00}h]" -f $total)
            $output += ""
        }

        if($mode -eq "業務時間"){
            $ts = $worktime["始業"] -split ":"
            $t1 = 60*[int]$ts[0]+[int]$ts[1]
            $ts = $worktime["終業"] -split ":"
            $t2 = 60*[int]$ts[0]+[int]$ts[1]
            $ts = $worktime["休憩"] -split ":"
            $t3 = 60*[int]$ts[0]+[int]$ts[1]
            $total = [double]($t2-$t1-$t3-60)/60.0

            $output += "- 始業 " + $worktime["始業"]
            $output += "- 終業 " + $worktime["終業"]
            $output += "- 休憩 " + $worktime["休憩"]
            $output += ("[total:{0:0.00}h]" -f $total)
            $output += ""
        }

        $mode = $matches[1]

        if ($mode -eq "今日のタスク"){
        }elseif($mode -eq "活動記録"){
            $output += "## 今日のタスク（予定/実績）"
        }else{
            $output += "## $mode"
        }
    }elseif($mode -eq "活動記録"){
        if($str -match "(?<t1>\d{2}):(?<t2>\d{2})-(?<t3>\d{2}):(?<t4>\d{2}) \[(?<cat>.*)\] (?<title>.*)"){
            $t1 = 60*[int]$matches["t1"]+[int]$matches["t2"]
            $t2 = 60*[int]$matches["t3"]+[int]$matches["t4"]
            $t3 = [double]($t2-$t1)/60.0
            $title = $matches["title"]
            if(-not $time.ContainsKey($title)){
                $time[$title] = @(0 ,0)
            }
            $time[$title][1] += $t3
            $cat = $matches["cat"]
            if(-not $category.ContainsKey($cat)){
                $category[$cat] = @()
            }
            if(-not ($category[$cat] -contains $title)){
                $category[$cat] += $title
            }
        }
    }elseif($mode -eq "今日のタスク"){
        if($str -match "^- \[.\] (?<cat>.*)"){
            $cat = $matches["cat"]
        }elseif($str -match "(?<t1>\d{2}):(?<t2>\d{2}) (?<title>.*)"){
            $t1 = 60*[int]$matches["t1"]+[int]$matches["t2"]
            $t2 = [double]($t1)/60.0
            $title = $matches["title"]
            if(-not $time.ContainsKey($title)){
                $time[$title] = @(0 ,0)
            }
            $time[$title][0] += $t2
            if(-not $category.ContainsKey($cat)){
                $category[$cat] = @()
            }
            if(-not ($category[$cat] -contains $title)){
                $category[$cat] += $title
            }
        }
    }elseif($mode -eq "業務時間"){
        if($str -match "\- (?<key>.*) (?<value>\d{2}:\d{2})"){
            $key = $matches["key"]
            $value = $matches["value"]
            $worktime[$key] = $value
        }
    }elseif($mode -eq "明日以降のタスク"){
        $str = $str -replace "\[ \] ", ""
        $output += $str
    }else{
        $output += $str
    }
}
