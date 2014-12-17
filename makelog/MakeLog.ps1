$inDir = "C:\shibata\note\2014"
$today = ("{0}.md" -f (Get-Date).ToString("yyyyMMdd"))
$yesterday = (Get-ChildItem $inDir | sort Name | select -Last 1).Name
$template01 = "C:\shibata\src\script\logging\makelog\template01.md"
$template02 = "C:\shibata\src\script\logging\makelog\template02.md"
$outPath = (Join-Path $inDir $today)

# �t�@�C���̑��݂��m�F
if(Test-Path $outPath){
    Write-Output "�t�@�C�������ɑ��݂��܂�"
    exit
}

# �e���v���[�g���R�s�[
Copy-Item $template01 $outPath

# ����̃^�X�N���R�s�[
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
    if($title -eq "�^�X�N"){
        $output += $str        
    }
}

# �e���v���[�g��ǋL
Get-Content $template02 -Encoding UTF8 | foreach{
    $output += $_
}

([string]::Join("`n", $output)) | Out-File $outPath -Encoding UTF8 -Append

Write-Output "�t�@�C�����쐬���܂���"
