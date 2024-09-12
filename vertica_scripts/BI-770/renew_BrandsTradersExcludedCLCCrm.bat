rem Фиксация в Vertica брендов игроков, исключаемых из расчета CRM параметров - BI-770

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\BrandsTrdsExclCL295CRM\RUN

del H:\OLAP\BrandsTrdsExclCL295CRM\endgetfvrt.txt

del H:\OLAP\BrandsTrdsExclCL295CRM\DATA\*.csv
del H:\OLAP\BrandsTrdsExclCL295CRM\RUN\*.rej
del H:\OLAP\BrandsTrdsExclCL295CRM\RUN\*.exc

cd /d H:\OLAP\BrandsTrdsExclCL295CRM\TEMP

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\BrandsTrdsExclCL295CRM\RUN\ftp_check_flg.in

if not EXIST H:\OLAP\BrandsTrdsExclCL295CRM\TEMP\end.flg goto _begget

ftp -n -v -i -s:H:\OLAP\BrandsTrdsExclCL295CRM\RUN\ftp.in

goto _endget
:_endget

copy /Y H:\OLAP\BrandsTrdsExclCL295CRM\TEMP\BrandsTradersExcludedCLCCrm.csv H:\OLAP\BrandsTrdsExclCL295CRM\DATA\BrandsTradersExcludedCLCCrm.csv /B

del H:\OLAP\BrandsTrdsExclCL295CRM\TEMP\end.flg

cd /d H:\OLAP\BrandsTrdsExclCL295CRM\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\BrandsTrdsExclCL295CRM\SCRIPTS\renew_BrandsTrdsExclCL295CRM.vsql -A -q -o  H:\OLAP\BrandsTrdsExclCL295CRM\RUN\renew_BrandsTrdsExclCL295CRM.vout
chcp 866

copy H:\OLAP\BrandsTrdsExclCL295CRM\null.txt H:\OLAP\BrandsTrdsExclCL295CRM\endgetfvrt.txt

exit 0
