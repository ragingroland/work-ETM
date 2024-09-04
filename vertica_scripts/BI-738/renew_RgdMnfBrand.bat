rem сделать табличку и скрипт под загрузку данных для хранения бренда товара согласно 488 признаку - BI-738

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0 

cd /d H:\OLAP\RgdMnfBrand\RUN

del H:\OLAP\RgdMnfBrand\endgetfvrt.txt

del H:\OLAP\RgdMnfBrand\DATA\*.csv
del H:\OLAP\RgdMnfBrand\RUN\*.rej
del H:\OLAP\RgdMnfBrand\RUN\*.exc

cd /d H:\OLAP\RgdMnfBrand\TEMP

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\RgdMnfBrand\RUN\ftp_check_flg.in

if not EXIST H:\OLAP\RgdMnfBrand\TEMP\end.flg goto _begget

ftp -n -v -i -s:H:\OLAP\RgdMnfBrand\RUN\ftp.in

goto _endget
:_endget

copy /Y H:\OLAP\RgdMnfBrand\TEMP\RgdMnfBrand.csv H:\OLAP\RgdMnfBrand\DATA\RgdMnfBrand.vcsv /B

del H:\OLAP\RgdMnfBrand\TEMP\end.flg

cd /d H:\OLAP\RgdMnfBrand\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\RgdMnfBrand\SCRIPTS\renew_RgdMnfBrand.vsql -A -q -o  H:\OLAP\RgdMnfBrand\RUN\renew_RgdMnfBrand.vout
chcp 866

copy H:\OLAP\RgdMnfBrand\null.txt H:\OLAP\RgdMnfBrand\endgetfvrt.txt

exit 0
