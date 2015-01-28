$inDir = "C:\shibata\note\current"
$outFile = "C:\Users\li2887\Desktop\�Α�.csv"
$mode = ""

# �Ɩ����Ԋ֘A
$attendance = @{}
$attendance["�n��"] = @{}
$attendance["�I��"] = @{}
$attendance["�x�e"] = @{}

# P#�֘A
$time = @{}
$times = @{}
$titles = @()

$ym = (Get-Date).ToString("yyyyMM")

# �ǂݍ���
for($i = 1; $i -le 31; $i++){
    $path = Join-Path $inDir ("{0}{1:00}.md" -f $ym, $i)
    if(Test-Path $path){
        # ������̍�Ǝ��Ԃ��擾
        $time = @{}
        Get-Content $path -Encoding UTF8 | foreach{
            $str = $_
            if($str -match "#+ (.*)"){
                $mode = $matches[1]
            }elseif($mode -eq "�Ɩ�����"){  # �Ɩ����Ԋ֘A
                if($str -match "\*\s+(?<type>�n��|�I��|�x�e)\s+(?<t1>\d{2}):(?<t2>\d{2})"){
                    $t3 = (60.0*[double]$matches["t1"]+[double]$matches["t2"])/60.0
                    $type = $matches["type"]
                    if($type -eq "�x�e" ){
                        $attendance[$type][$i] = $t3+1.0
                    }else{
                        $attendance[$type][$i] = $t3
                    }
                }
            }elseif($mode -eq "����"){  # P#�֘A
                if($str -match "(?<t1>\d{2}):(?<t2>\d{2})-(?<t3>\d{2}):(?<t4>\d{2}) \[(?<cat>.*)\] (?<title>.*)"){
                    $t1 = 60*[int]$matches["t1"]+[int]$matches["t2"]
                    $t2 = 60*[int]$matches["t3"]+[int]$matches["t4"]
                    $t3 = [double]($t2-$t1)/60.0
                    # ��Ɠ��e�ƍ�Ǝ��Ԃ�R�t��
                    $title = ("{0},{1}" -f $matches["cat"], $matches["title"])
                    if(-not $time.ContainsKey($title)){
                        $time[$title] = 0
                    }
                    $time[$title] += $t3
                    # ��Ɠ��e��o�^
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
# �o�́i�w�b�_�j
$output = @()
$output += ","
for($i = 1; $i -le 31; $i++){
    $output += $i
}
([string]::Join(",", $output)) | Out-File $outFile -Encoding UTF8 -Append
# �o�́i�Ɩ����Ԋ֌W�j
foreach($key in @("�n��","�I��","�x�e")){
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
# �o�́i��؂�j
"" | Out-File $outFile -Encoding UTF8 -Append
# �o�́i�w�b�_�j
$output = @()
$output += "�J�e�S��,��Ɠ��e"
for($i = 1; $i -le 31; $i++){
    $output += $i
}
([string]::Join(",", $output)) | Out-File $outFile -Encoding UTF8 -Append
# �o�́iP#�֘A�j
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
