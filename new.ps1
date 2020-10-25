Param(
    [ValidateSet("blogs", "news", "posts")][String]$Arg
)
$now_date=Get-Date -UFormat "+%Y-%m-%d-%H%M"
.\hugo.exe new $Arg\"$now_date\index.md"
Write-Host "Congratulations!!"
Write-Host "content\$Arg\$now_date\index.md was created!"
Write-Host "Edit and Deploy!"