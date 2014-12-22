$inDir = "c:\shibata\note\2014"
$outFile = "c:\shibata\tmp\search.md"

$output = @()

Get-ChildItem $inDir | sort -descending | foreach{
  $output += "# $_`n"
  $inTargetSection = $FALSE
  Get-Content $_.Fullname -Encoding UTF8 | foreach{
    $str = $_

    if($str -eq "# 業務記録"){
      $inTargetSection = $TRUE
    }elseif($str -eq "----"){
      $inTargetSection = $FALSE
    }elseif($inTargetSection){
      $output += $str
    }
  }
  $output += "`n----`n"
}

([string]::Join("`n", $output)) | Out-File $outFile -Encoding UTF8
