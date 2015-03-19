$inDir = "D:\shibata\note\current"
$outFile = "D:\shibata\tmp\日報.txt"

$today = (Get-Date).ToString("yyyyMMdd")
$inFile = "$inDir\$today.md"

$mode = ""
$time = @{}
$category = @{}
$output = @()
$worktime = @{"始業"="09:30"; "終業"="17:30"; "休憩"="00:00"}

Get-Content $inFile -Encoding UTF8 | foreach{
    $str = $_.Replace("`t","  ")
    if($str -eq "----"){
        ([string]::Join("`n", $output)) | Out-File $outFile -Encoding UTF8
        exit
    }elseif($str -eq "# 日報"){
    }elseif($str -match "## (.*)"){
        if($mode -eq "実績"){
            $total = 0
            foreach($cat in $category.Keys){
                $output += "* $cat"
                foreach($title in $category[$cat]){
                    $t = $time[$title]
                    $total += $t
                    $tStr = ""
                    $output += ("  * {0} ({1:0.00}h)" -f $title, $t)
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

            $output += "* 始業 " + $worktime["始業"]
            $output += "* 終業 " + $worktime["終業"]
            $output += "* 休憩 " + $worktime["休憩"]
            $output += ("[total:{0:0.00}h]" -f $total)
            $output += ""
        }

        $mode = $matches[1]
        $output += "■$mode"
    }elseif($mode -eq "実績"){
        if($str -match "(?<t1>\d{2}):(?<t2>\d{2})-(?<t3>\d{2}):(?<t4>\d{2}) \[(?<cat>.*)\] (?<title>.*)"){
            $t1 = 60*[int]$matches["t1"]+[int]$matches["t2"]
            $t2 = 60*[int]$matches["t3"]+[int]$matches["t4"]
            $t3 = [double]($t2-$t1)/60.0
            $title = $matches["title"]
            if(-not $time.ContainsKey($title)){
                $time[$title] = 0
            }
            $time[$title] += $t3
            $cat = $matches["cat"]
            if(-not $category.ContainsKey($cat)){
                $category[$cat] = @()
            }
            if(-not ($category[$cat] -contains $title)){
                $category[$cat] += $title
            }
        }
    }elseif($mode -eq "業務時間"){
        if($str -match "\* (?<key>.*) (?<value>\d{2}:\d{2})"){
            $key = $matches["key"]
            $value = $matches["value"]
            $worktime[$key] = $value
        }
    }else{
        $output += $str
    }
}
