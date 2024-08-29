rem Автоматизация загрузки таблицы price_comp_parse_nets - BI-745

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0
IF NOT EXIST \\cpfs1.etm.corp\price_comp_parse_nets\PricingNetRegionCompany\price_comp_parse_nets.csv exit 0

setlocal enableextensions

cd /d H:\OLAP\price_comp_parse_nets\RUN

del H:\OLAP\price_comp_parse_nets\endgetfvrt.txt

del H:\OLAP\price_comp_parse_nets\DATA\*.csv
del H:\OLAP\price_comp_parse_nets\DATA\*.vcsv
del H:\OLAP\price_comp_parse_nets\RUN\*.rej
del H:\OLAP\price_comp_parse_nets\RUN\*.exc

cd /d H:\OLAP\price_comp_parse_nets\DATA

:_beg

ping -n 100 relay.etm.spb.ru >nul

move \\cpfs1.etm.corp\price_comp_parse_nets\PricingNetRegionCompany\price_comp_parse_nets.csv H:\OLAP\price_comp_parse_nets\DATA\price_comp_parse_nets.csv

for %%f in (*.csv) do (
    echo Converting %%f to %%~nf.vcsv...
    powershell.exe -Command "Get-Content '%%f' | Set-Content -Encoding utf8 '%%~nf.vcsv'"
    powershell -Command "&{ param($Path); $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False); $MyFile = Get-Content $Path; [System.IO.File]::WriteAllLines($Path, $MyFile, $Utf8NoBomEncoding) }" %%~nf.vcsv
)
goto _end

:_end

cd /d H:\OLAP\price_comp_parse_nets\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\price_comp_parse_nets\SCRIPTS\renew_price_comp_parse_nets.vsql -A -q -o  H:\OLAP\price_comp_parse_nets\RUN\renew_price_comp_parse_nets.vout
chcp 866

copy H:\OLAP\price_comp_parse_nets\null.txt H:\OLAP\price_comp_parse_nets\endgetfvrt.txt

exit 0
