rem Разработка витрин для блока "Федеральный отчет по дивизионам" - BI-787

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\DshMCB_FedRepQrt\RUN

del H:\OLAP\DshMCB_FedRepQrt\endgetfvrt.txt
del H:\OLAP\DshMCB_FedRepQrt\RUN\*.rej
del H:\OLAP\DshMCB_FedRepQrt\RUN\*.exc

:_begget
ping -n 100 relay.etm.spb.ru >nul

if not EXIST I:\common-spr\endgetfvrt.txt goto _begget
if not EXIST H:\OLAP\CBStatTrader\endgetfvrt.txt goto _begget

goto _endget
:_endget

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshMCB_FedRepQrt\SCRIPTS\renew_DshMCB_FedRepQrt_TrnOvr.vsql -A -q -o  H:\OLAP\DshMCB_FedRepQrt\RUN\renew_DshMCB_FedRepQrt_TrnOvr.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshMCB_FedRepQrt\SCRIPTS\renew_DshMCB_FedRepQrt_TrnOvrTerr.vsql -A -q -o  H:\OLAP\DshMCB_FedRepQrt\RUN\renew_DshMCB_FedRepQrt_TrnOvrTerr.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshMCB_FedRepQrt\SCRIPTS\renew_DshMCB_FedRepQrt_TrnOvrFact.vsql -A -q -o  H:\OLAP\DshMCB_FedRepQrt\RUN\renew_DshMCB_FedRepQrt_TrnOvrFact.vout
chcp 866

copy H:\OLAP\DshMCB_FedRepQrt\null.txt H:\OLAP\DshMCB_FedRepQrt\endgetfvrt.txt

exit 0
