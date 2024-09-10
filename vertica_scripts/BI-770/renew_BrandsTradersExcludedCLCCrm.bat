rem Фиксация в Vertica брендов игроков, исключаемых из расчета CRM параметров - BI-770

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\BrandsTradersExcludedCLCCrm\RUN

del H:\OLAP\BrandsTradersExcludedCLCCrm\endgetfvrt.txt

del H:\OLAP\BrandsTradersExcludedCLCCrm\DATA\*.csv
del H:\OLAP\BrandsTradersExcludedCLCCrm\RUN\*.rej
del H:\OLAP\BrandsTradersExcludedCLCCrm\RUN\*.exc

cd /d H:\OLAP\BrandsTradersExcludedCLCCrm\TEMP

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\BrandsTradersExcludedCLCCrm\RUN\ftp_check_flg.in

if not EXIST H:\OLAP\BrandsTradersExcludedCLCCrm\TEMP\end.flg goto _begget

ftp -n -v -i -s:H:\OLAP\BrandsTradersExcludedCLCCrm\RUN\ftp.in

goto _endget
:_endget

copy /Y H:\OLAP\BrandsTradersExcludedCLCCrm\TEMP\BrandsTradersExcludedCLCCrm.csv H:\OLAP\BrandsTradersExcludedCLCCrm\DATA\BrandsTradersExcludedCLCCrm.csv /B

del H:\OLAP\BrandsTradersExcludedCLCCrm\TEMP\end.flg

cd /d H:\OLAP\BrandsTradersExcludedCLCCrm\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\BrandsTradersExcludedCLCCrm\SCRIPTS\renew_BrandsTradersExcludedCLCCrm.vsql -A -q -o  H:\OLAP\BrandsTradersExcludedCLCCrm\RUN\renew_BrandsTradersExcludedCLCCrm.vout
chcp 866

copy H:\OLAP\BrandsTradersExcludedCLCCrm\null.txt H:\OLAP\BrandsTradersExcludedCLCCrm\endgetfvrt.txt

exit 0
