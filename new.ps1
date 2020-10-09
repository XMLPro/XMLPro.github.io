Param(
    [ValidateSet("blogs", "news", "posts")][String]$Arg
)
$now_date=Get-Date -UFormat "+%Y-%m-%d-%H%M"
.\hugo.exe new $Arg\"$now_date.md"
Write-Host "Congratulations!!"
Write-Host "content\$Arg\$now_date.md was created!"
Write-Host "Edit and Deploy!"