rem BI-МКБ: Разработка витрин для блока "Работа с КБ" - BI-879

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\DshMCB_KBWrk\RUN

del H:\OLAP\DshMCB_KBWrk\endgetfvrt.txt

:_begget
ping -n 100 relay.etm.spb.ru >nul

if not EXIST I:\common-spr\endgetfvrt.txt goto _begget
if not EXIST H:\OLAP\CBStatTrader\endgetfvrt.txt goto _begget

goto _endget
:_endget

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshMCB_KBWrk\SCRIPTS\renew_DshMCB_KBWrkPCB.vsql -A -q -o  H:\OLAP\DshMCB_KBWrk\RUN\renew_DshMCB_KBWrkPCB.vout
chcp 866


copy H:\OLAP\DshMCB_KBWrk\null.txt H:\OLAP\DshMCB_KBWrk\endgetfvrt.txt

exit 0
