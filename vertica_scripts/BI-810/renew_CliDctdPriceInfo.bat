rem Vertica - 䨪��� ������ �� 522-� �ਧ����� � �࣠������ �� �।��⠢�塞� 業�� - BI-810

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\CliDctdPriceInfo\RUN

del H:\OLAP\CliDctdPriceInfo\endgetfvrt.txt

del H:\OLAP\CliDctdPriceInfo\DATA\*.csv
del H:\OLAP\CliDctdPriceInfo\RUN\*.rej
del H:\OLAP\CliDctdPriceInfo\RUN\*.exc
del H:\OLAP\CliDctdPriceInfo\TEMP\*.flg

cd /d H:\OLAP\CliDctdPriceInfo\TEMP

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\CliDctdPriceInfo\RUN\ftp_check_flg.in

if not EXIST H:\OLAP\CliDctdPriceInfo\TEMP\end.flg goto _begget

ftp -n -v -i -s:H:\OLAP\CliDctdPriceInfo\RUN\ftp.in

goto _endget
:_endget

copy /Y H:\OLAP\CliDctdPriceInfo\TEMP\CenaFrom522.csv H:\OLAP\CliDctdPriceInfo\DATA\CenaFrom522.csv /B

cd /d H:\OLAP\CliDctdPriceInfo\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\CliDctdPriceInfo\SCRIPTS\renew_CliDctdPriceInfo.vsql -A -q -o  H:\OLAP\CliDctdPriceInfo\RUN\renew_CliDctdPriceInfo.vout
chcp 866

copy H:\OLAP\CliDctdPriceInfo\null.txt H:\OLAP\CliDctdPriceInfo\endgetfvrt.txt

exit 0
