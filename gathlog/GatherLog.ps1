$inDir = "C:\shibata\note\current"
$outFile = "C:\Users\li2887\Desktop\勤怠.csv"
$mode = ""

# 業務時間関連
$attendance = @{}
$attendance["始業"] = @{}
$attendance["終業"] = @{}
$attendance["休憩"] = @{}

# P#関連
$time = @{}
$times = @{}
$titles = @()

$ym = (Get-Date).ToString("yyyyMM")

# 読み込み
for($i = 1; $i -le 31; $i++){
    $path = Join-Path $inDir ("{0}{1:00}.md" -f $ym, $i)
    if(Test-Path $path){
        # 特定日の作業時間を取得
        $time = @{}
        Get-Content $path -Encoding UTF8 | foreach{
            $str = $_
            if($str -match "#+ (.*)"){
                $mode = $matches[1]
            }elseif($mode -eq "業務時間"){  # 業務時間関連
                if($str -match "\*\s+(?<type>始業|終業|休憩)\s+(?<t1>\d{2}):(?<t2>\d{2})"){
                    $t3 = (60.0*[double]$matches["t1"]+[double]$matches["t2"])/60.0
                    $type = $matches["type"]
                    if($type -eq "休憩" ){
                        $attendance[$type][$i] = $t3+1.0
                    }else{
                        $attendance[$type][$i] = $t3
                    }
                }
            }elseif($mode -eq "実績"){  # P#関連
                if($str -match "(?<t1>\d{2}):(?<t2>\d{2})-(?<t3>\d{2}):(?<t4>\d{2}) \[(?<cat>.*)\] (?<title>.*)"){
                    $t1 = 60*[int]$matches["t1"]+[int]$matches["t2"]
                    $t2 = 60*[int]$matches["t3"]+[int]$matches["t4"]
                    $t3 = [double]($t2-$t1)/60.0
                    # 作業内容と作業時間を紐付け
                    $title = ("{0},{1}" -f $matches["cat"], $matches["title"])
                    if(-not $time.ContainsKey($title)){
                        $time[$title] = 0
                    }
                    $time[$title] += $t3
                    # 作業内容を登録
                    if(-not ($titles -contains $title)){
                        $titles += $title
                    }
                }
            }
        }
        $times[$i] = $time
    }
}

"" | Out-File $outFile -Encoding UTF8
# 出力（ヘッダ）
$output = @()
$output += ","
for($i = 1; $i -le 31; $i++){
    $output += $i
}
([string]::Join(",", $output)) | Out-File $outFile -Encoding UTF8 -Append
# 出力（業務時間関係）
foreach($key in @("始業","終業","休憩")){
    $output = @()
    $output += ",$key"
    for($i = 1; $i -le 31; $i++){
        if($attendance[$key].ContainsKey($i)){
            $output += $attendance[$key][$i]
        }else{
            $output += ""
        }
    }
    ([string]::Join(",", $output)) | Out-File $outFile -Encoding UTF8 -Append
}
# 出力（区切り）
"" | Out-File $outFile -Encoding UTF8 -Append
# 出力（ヘッダ）
$output = @()
$output += "カテゴリ,作業内容"
for($i = 1; $i -le 31; $i++){
    $output += $i
}
([string]::Join(",", $output)) | Out-File $outFile -Encoding UTF8 -Append
# 出力（P#関連）
foreach($title in $titles){
    $output = @()
    $output += "$title"
    for($i = 1; $i -le 31; $i++){
        if($times.ContainsKey($i) -and $times[$i].ContainsKey($title)){
            $output += $times[$i][$title]
        }else{
            $output += ""
        }
    }
    ([string]::Join(",", $output)) | Out-File $outFile -Encoding UTF8 -Append
}
