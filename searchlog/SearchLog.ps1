$inDir = "D:\shibata\note\current"
$outFile = "D:\shibata\tmp\search.md"

$output = @()

Get-ChildItem $inDir | sort -descending | foreach{
  $output += "# $_`n"
  $mode = ""
  $modeSub = ""
  Get-Content $_.Fullname -Encoding UTF8 | foreach{
    $str = $_

    if($str -match "^# (.*)"){
      $mode = $matches[1]
      return
    }
    if($str -match "^## (.*)"){
      $modeSub = $matches[1]
    }

    if(($mode -eq "日報" -and $modeSub -eq "報告") -or ($mode -eq "業務記録" -and $modeSub -ne "タスク")){
      $output += $str
    }
  }
  $output += "`n----`n"
}

([string]::Join("`n", $output)) | Out-File $outFile -Encoding UTF8
