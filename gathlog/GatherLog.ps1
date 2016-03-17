$ym = $args[0]

$inDir = "D:\shibata\note\current"
$outFile = "C:\Users\li2887\Desktop\勤怠工数_${ym}.csv"
$mode = ""

# P#関連
$time = @{}
$times = @{}
$titles = @()

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

# 出力（ヘッダ）
$output = @()
$output += "カテゴリ,作業内容"
for($i = 1; $i -le 31; $i++){
    $output += $i
}
([string]::Join(",", $output)) | Out-File $outFile -Encoding UTF8
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
