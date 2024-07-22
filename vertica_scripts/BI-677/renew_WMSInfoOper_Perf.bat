rem Организовать хранение в Vertica (отчет WMS по операциям) - "Производительность СК ЛЦ" BI-677

setlocal enableextensions

cd /d H:\OLAP\WMSInfoOper_Perf\RUN

del H:\OLAP\WMSInfoOper_Perf\endgetfvrt.txt

del H:\OLAP\WMSInfoOper_Perf\DATA\*.csv
del H:\OLAP\WMSInfoOper_Perf\DATA\*.vcsv
del H:\OLAP\WMSInfoOper_Perf\RUN\*.rej
del H:\OLAP\WMSInfoOper_Perf\RUN\*.exc

:_beg

ping -n 100 relay.etm.spb.ru >nul
 
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\EKB.csv goto _beg
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\KZN.csv goto _beg
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\MSK.csv goto _beg
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\MY.csv goto _beg
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\NSK.csv goto _beg
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\RND.csv goto _beg
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\SAM.csv goto _beg
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\SPB.csv goto _beg
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\VRN.csv goto _beg

copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\EKB.csv H:\OLAP\WMSInfoOper_Perf\DATA\EKB.csv
copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\KZN.csv H:\OLAP\WMSInfoOper_Perf\DATA\KZN.csv
copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\MSK.csv H:\OLAP\WMSInfoOper_Perf\DATA\MSK.csv
copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\MY.csv H:\OLAP\WMSInfoOper_Perf\DATA\MY.csv
copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\NSK.csv H:\OLAP\WMSInfoOper_Perf\DATA\NSK.csv
copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\RND.csv H:\OLAP\WMSInfoOper_Perf\DATA\RND.csv
copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\SAM.csv H:\OLAP\WMSInfoOper_Perf\DATA\SAM.csv
copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\SPB.csv H:\OLAP\WMSInfoOper_Perf\DATA\SPB.csv
copy \\cpfs1.etm.corp\DataLoadVertica\WMSProductivLC\VRN.csv H:\OLAP\WMSInfoOper_Perf\DATA\VRN.csv

for %%f in (*.csv) do (
    echo Converting %%f to %%~nf.vcsv...
    powershell.exe -Command "Get-Content '%%f' | Set-Content -Encoding utf8 '%%~nf.vcsv'"
)
echo Done!

path=%path%;C:\Program Files\Vertica Systems\VSQL64
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\WMSInfoOper_Perf\SCRIPTS\renew_WMSInfoOper_Perf.vsql -A -q -o  H:\OLAP\WMSInfoOper_Perf\RUN\renew_WMSInfoOper_Perf.vout
chcp 866

:_end

copy H:\OLAP\WMSInfoOper_Perf\null.txt H:\OLAP\WMSInfoOper_Perf\endgetfvrt.txt

exit 0