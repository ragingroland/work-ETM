rem создать табличку для хранения 220-й классификации товара - BI-711

setlocal enableextensions

cd /d H:\OLAP\RgdLinkClass220\RUN

del H:\OLAP\RgdLinkClass220\endgetfvrt.txt

del H:\OLAP\RgdLinkClass220\DATA\*.csv
del H:\OLAP\RgdLinkClass220\RUN\*.rej
del H:\OLAP\RgdLinkClass220\RUN\*.exc

cd /d H:\OLAP\RgdLinkClass220\TEMP

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\RgdLinkClass220\RUN\ftp_check_flg.in

if not EXIST H:\OLAP\RgdLinkClass220\TEMP\end.flg goto _begget

ftp -n -v -i -s:H:\OLAP\RgdLinkClass220\RUN\ftp.in

goto _endget
:_endget

copy /Y H:\OLAP\RgdLinkClass220\TEMP\RgdLinkClass220.csv H:\OLAP\RgdLinkClass220\DATA\RgdLinkClass220.csv /B

del H:\OLAP\RgdLinkClass220\TEMP\end.flg

cd /d H:\OLAP\RgdLinkClass220\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\RgdLinkClass220\SCRIPTS\renew_RgdLinkClass220.vsql -A -q -o  H:\OLAP\RgdLinkClass220\RUN\renew_RgdLinkClass220.vout
chcp 866

copy H:\OLAP\RgdLinkClass220\null.txt H:\OLAP\RgdLinkClass220\endgetfvrt.txt

exit 0
