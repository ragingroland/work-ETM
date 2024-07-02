rem фиксация первичных данных по "Контроль своевременности прибытия к клиентам"

setlocal enableextensions
IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0
cd /d H:\OLAP\CliDelivCtrl\RUN

del  H:\OLAP\CliDelivCtrl\RUN\renew_CliDeliverCtrl.vout
del  H:\OLAP\CliDelivCtrl\RUN\renew_CliDeliverCtrl.rej
del  H:\OLAP\CliDelivCtrl\RUN\renew_CliDeliverCtrl.exc
del  H:\OLAP\CliDelivCtrl\endgetvrt_CliDeliverCtrl.txt
del  H:\OLAP\CliDelivCtrl\DATA\*.csv
del  H:\OLAP\CliDelivCtrl\DATA\*.vcsv
del  H:\OLAP\CliDelivCtrl\TEMP\*.csv
del  H:\OLAP\CliDelivCtrl\TEMP\end.flg

cd /d H:\OLAP\CliDelivCtrl\TEMP

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\CliDelivCtrl\RUN\ftp_check_flg.in

if not EXIST H:\OLAP\CliDelivCtrl\TEMP\end.flg goto _begget

ftp -n -v -i -s:H:\OLAP\CliDelivCtrl\RUN\ftp.in

goto _endget
:_endget

del H:\OLAP\CliDelivCtrl\TEMP\end.flg

cd /d H:\OLAP\CliDelivCtrl\RUN

 
copy /Y H:\OLAP\CliDelivCtrl\TEMP\t-rep005.csv H:\OLAP\CliDelivCtrl\DATA\t-rep005.csv /B
del H:\OLAP\CliDelivCtrl\TEMP\t-rep005.csv


powershell.exe "Get-Content H:\OLAP\CliDelivCtrl\DATA\t-rep005.csv  | Set-Content -Encoding utf8 H:\OLAP\CliDelivCtrl\DATA\t-rep005.vcsv"  

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\CliDelivCtrl\SCRIPTS\renew_CliDeliverCtrl.vsql  -A -q -o H:\OLAP\CliDelivCtrl\RUN\renew_CliDeliverCtrl.vout
chcp 866 

if exist H:\OLAP\CliDelivCtrl\RUN\renew_CliDeliverCtrl.rej exit 0
if exist H:\OLAP\CliDelivCtrl\RUN\renew_CliDeliverCtrl.exc exit 0

copy H:\OLAP\CliDelivCtrl\null.txt H:\OLAP\CliDelivCtrl\endgetvrt_CliDelivCtrl.txt

exit 0
