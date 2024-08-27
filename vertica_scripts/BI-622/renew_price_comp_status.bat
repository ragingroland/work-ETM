rem табличка настройки мониторинга конкурентов по регионам BI-622

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

setlocal enableextensions

cd /d H:\OLAP\price_comp_status\RUN

del H:\OLAP\price_comp_status\endgetfvrt.txt

del H:\OLAP\price_comp_status\DATA\*.csv
del H:\OLAP\price_comp_status\DATA\*.vcsv
del H:\OLAP\price_comp_status\RUN\*.rej
del H:\OLAP\price_comp_status\RUN\*.exc

:_beg

ping -n 100 relay.etm.spb.ru >nul
 
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\PricingCompanyStatus\price_comp_status.csv goto _beg

copy \\cpfs1.etm.corp\DataLoadVertica\PricingCompanyStatus\price_comp_status.csv H:\OLAP\price_comp_status\DATA\price_comp_status.csv

powershell.exe "Get-Content H:\OLAP\price_comp_status\DATA\price_comp_status.csv  | Set-Content -Encoding utf8 H:\OLAP\price_comp_status\DATA\price_comp_status.vcsv"  

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\price_comp_status\SCRIPTS\renew_price_comp_status.vsql -A -q -o  H:\OLAP\price_comp_status\RUN\renew_price_comp_status.vout
chcp 866

copy H:\OLAP\price_comp_status\null.txt H:\OLAP\price_comp_status\endgetfvrt.txt

goto _end

:_end

exit 0