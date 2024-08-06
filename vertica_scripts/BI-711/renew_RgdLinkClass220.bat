rem создать табличку для хранения 220-й классификации товара - BI-711

setlocal enableextensions

cd /d H:\OLAP\RgdLinkClass220\RUN

del H:\OLAP\RgdLinkClass220\endgetfvrt.txt

del H:\OLAP\RgdLinkClass220\DATA\*.csv
del H:\OLAP\RgdLinkClass220\RUN\*.rej
del H:\OLAP\RgdLinkClass220\RUN\*.exc

:_beg

ping -n 100 relay.etm.spb.ru >nul
 
if not EXIST \\cpfs1.etm.corp\DataLoadVertica\RgdLinkClass220\RgdLinkClass220.csv goto _beg

copy \\cpfs1.etm.corp\DataLoadVertica\RgdLinkClass220\RgdLinkClass220.csv H:\OLAP\RgdLinkClass220\DATA\RgdLinkClass220.csv

rem for %%f in (*.csv) do (
rem     echo Converting %%f to %%~nf.vcsv...
rem     powershell.exe -Command "Get-Content '%%f' | Set-Content -Encoding utf8 '%%~nf.vcsv'"
rem )
rem echo Done!

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\RgdLinkClass220\SCRIPTS\renew_RgdLinkClass220.vsql -A -q -o  H:\OLAP\RgdLinkClass220\RUN\renew_RgdLinkClass220.vout
chcp 866

copy H:\OLAP\RgdLinkClass220\null.txt H:\OLAP\RgdLinkClass220\endgetfvrt.txt

goto _end

:_end

exit 0