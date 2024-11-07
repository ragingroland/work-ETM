rem BI-E-com: разработка витрин для блока "Сводные данные по рекламным кампаниям" BI-793

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\DshECom_AnlsAdvSumData\RUN

del H:\OLAP\DshECom_AnlsAdvSumData\endgetfvrt.txt
del H:\OLAP\DshECom_AnlsAdvSumData\RUN\di.flg

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\DshECom_AnlsAdvSumData\RUN\ftp_check_flg.in
if not exist H:\OLAP\DshECom_AnlsAdvSumData\RUN\di.flg goto _begget

goto _endget
:_endget

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_AnlsAdvSumData\SCRIPTS\renew_DshECom_AnlsAdvSumData.vsql -A -q -o  H:\OLAP\DshECom_AnlsAdvSumData\RUN\renew_DshECom_AnlsAdvSumData.vout
chcp 866

copy H:\OLAP\DshECom_AnlsAdvSumData\null.txt H:\OLAP\DshECom_AnlsAdvSumData\endgetfvrt.txt

exit 0
