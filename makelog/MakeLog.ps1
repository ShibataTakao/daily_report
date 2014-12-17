$inDir = "C:\shibata\note\2014"
$today = ("{0}.md" -f (Get-Date).ToString("yyyyMMdd"))
$yesterday = (Get-ChildItem $inDir | sort Name | select -Last 1).Name
$template01 = "C:\shibata\src\script\logging\makelog\template01.md"
$template02 = "C:\shibata\src\script\logging\makelog\template02.md"
$outPath = (Join-Path $inDir $today)

# ファイルの存在を確認
if(Test-Path $outPath){
    Write-Output "ファイルが既に存在します"
    exit
}

# テンプレートをコピー
Copy-Item $template01 $outPath

# 先日のタスクをコピー
$inPath = Join-Path $inDir $yesterday
$output = @()
$title = ""
Get-Content $inPath -Encoding UTF8 | foreach{
    $str = $_
    if($str -match "^# (?<title>.*)"){
        $title = $matches["title"]
    }
    if($str -eq "----"){
        $title = ""
    }
    if($title -eq "タスク"){
        $output += $str        
    }
}

# テンプレートを追記
Get-Content $template02 -Encoding UTF8 | foreach{
    $output += $_
}

([string]::Join("`n", $output)) | Out-File $outPath -Encoding UTF8 -Append

Write-Output "ファイルを作成しました"
