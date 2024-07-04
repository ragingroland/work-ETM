rem Разработка витрин для "Своевременность доставок"

setlocal enableextensions

cd /d H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN

del  H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN\renew_DshLogistManag_OnTimeDeliv_Day.vout
del  H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN\renew_DshLogistManag_OnTimeDeliv_Day.rej
del  H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN\renew_DshLogistManag_OnTimeDeliv_Day.exc
del  H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\endgetvrt_DshLogistManag_OnTimeDeliv_Day.txt

del  H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN\renew_DshLogistManag_OnTimeDeliv_Mnth.vout
del  H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN\renew_DshLogistManag_OnTimeDeliv_Mnth.rej
del  H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN\renew_DshLogistManag_OnTimeDeliv_Mnth.exc
del  H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\endgetvrt_DshLogistManag_OnTimeDeliv_Mnth.txt

:_beg

ping -n 100 relay.etm.spb.ru > nul

if not EXIST I:\common-spr\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\CliDelivCtrl\endgetfvrt_CliDelivCtrl.txt goto _beg
if not EXIST H:\OLAP\StoreLinkClass10\endgetfvrt.txt goto _beg
 

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\SCRIPTS\renew_DshLogistManag_OnTimeDeliv_Day.vsql  -A -q -o H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN\renew_DshLogistManag_OnTimeDeliv_Day.vout
chcp 866 

copy H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\null.txt H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\endgetvrt_DshLogistManag_OnTimeDeliv_Day.txt

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\SCRIPTS\renew_DshLogistManag_OnTimeDeliv_Mnth.vsql  -A -q -o H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\RUN\renew_DshLogistManag_OnTimeDeliv_Mnth.vout
chcp 866 

copy H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\null.txt H:\OLAP\DshLogistManag_OnTimeDeliv_day_mnth\endgetvrt_DshLogistManag_OnTimeDeliv_Mnth.txt

goto _end

:_end

exit 0