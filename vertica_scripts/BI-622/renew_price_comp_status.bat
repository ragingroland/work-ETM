rem табличка настройки мониторинга конкурентов по регионам BI-622

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0
IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\PricingCompanyStatus\price_comp_status.csv exit 0

setlocal enableextensions

cd /d H:\OLAP\price_comp_status\RUN

del H:\OLAP\price_comp_status\endgetfvrt.txt

del H:\OLAP\price_comp_status\DATA\*.csv
del H:\OLAP\price_comp_status\DATA\*.vcsv
del H:\OLAP\price_comp_status\RUN\*.rej
del H:\OLAP\price_comp_status\RUN\*.exc
del H:\OLAP\price_comp_status\RUN\*.vout

cd /d H:\OLAP\price_comp_status\DATA

:_beg

rem ping -n 100 relay.etm.spb.ru >nul

move \\cpfs1.etm.corp\DataLoadVertica\PricingCompanyStatus\price_comp_status.csv H:\OLAP\price_comp_status\DATA\price_comp_status.csv

for %%f in (*.csv) do (
    echo Converting %%f to %%~nf.vcsv...
    powershell.exe -Command "Get-Content '%%f' | Set-Content -Encoding utf8 '%%~nf.vcsv'"
    powershell -Command "&{ param($Path); $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False); $MyFile = Get-Content $Path; [System.IO.File]::WriteAllLines($Path, $MyFile, $Utf8NoBomEncoding) }" %%~nf.vcsv
)

goto _end

:_end

cd /d H:\OLAP\price_comp_status\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\price_comp_status\SCRIPTS\renew_price_comp_status.vsql -A -q -o  H:\OLAP\price_comp_status\RUN\renew_price_comp_status.vout
chcp 866

IF EXIST H:\OLAP\price_comp_status\RUN\price_comp_status.rej H:\OLAP\price_comp_status\RUN\postie.exe -gmt -host:relay.etm.spb.ru -tolist:H:\OLAP\price_comp_status\RUN\sendme_err_src.file -from:base@etm.spb.ru -s:"Произошли ошибки загрузки из price_comp_status.csv" -a:price_comp_status.rej -charset:windows-1251

copy H:\OLAP\price_comp_status\null.txt H:\OLAP\price_comp_status\endgetfvrt.txt

exit 0
