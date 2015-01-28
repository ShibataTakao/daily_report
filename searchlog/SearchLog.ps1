$inDir = "c:\shibata\note\current"
$outFile = "c:\shibata\tmp\search.md"

$output = @()

Get-ChildItem $inDir | sort -descending | foreach{
  $output += "# $_`n"
  $inTargetSection = $FALSE
  $inTargetSection2 = $FALSE
  Get-Content $_.Fullname -Encoding UTF8 | foreach{
    $str = $_

    if($str -eq "# 業務記録"){
      $inTargetSection = $TRUE
    }elseif($str -eq "----"){
      $inTargetSection = $FALSE
    }elseif($str -eq "## 報告"){
      $inTargetSection2 = $TRUE
      $output += $str
    }elseif($inTargetSection2 -and ($str -match "## .*")){
      $inTargetSection2 = $FALSE
    }elseif($inTargetSection -or $inTargetSection2){
      $output += $str
    }
  }
  $output += "`n----`n"
}

([string]::Join("`n", $output)) | Out-File $outFile -Encoding UTF8
