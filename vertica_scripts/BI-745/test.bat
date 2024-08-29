rem Автоматизация загрузки таблицы price_comp_parse_nets - BI-745

cd /d C:\Users\ivanov_vvx\work\vertica_scripts\BI-745\

:_beg

for %%f in (*.csv) do (
    echo Converting %%f to %%~nf.vcsv...
    powershell.exe -Command "Get-Content '%%f' | Set-Content -Encoding utf8 '%%~nf.vcsv'"
    powershell -Command "&{ param($Path); $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False); $MyFile = Get-Content $Path; [System.IO.File]::WriteAllLines($Path, $MyFile, $Utf8NoBomEncoding) }" %%~nf.vcsv
)
goto _end

:_end

exit 0
