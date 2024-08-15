rem разработка витрин для ДБ УП эффективность МОПП BI-576

setlocal enableextensions

cd /d H:\OLAP\DshSalesManag_EfDSMSheet\RUN


del  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_SalePlanFact.vout
del  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_SalePlanFact.rej
del  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_SalePlanFact.exc

del  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_PlanStaffAll.vout
del  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_PlanStaffAll.rej
del  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_PlanStaffAll.exc

del  H:\OLAP\DshSalesManag_EfDSMSheet\endgetvrt_DshSalesManag_EfDSMSheet_SalePlanFact.txt
del  H:\OLAP\DshSalesManag_EfDSMSheet\endgetvrt_DshSalesManag_EfDSMSheet_PlanStaffAll.txt


:_beg
ping -n 100 relay.etm.spb.ru > nul

if not EXIST I:\common-spr\endgetfvrt.txt goto _beg
if not EXIST I:\go_common\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\OneC_RfBk\endgetfvrt_RfBk.txt goto _beg
if not EXIST H:\OLAP\OneC_StaffSchedPlan\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\OneC_NumberEmpl\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\PlanTargManManuf\endgetfvrt.txt goto _beg


path=%path%;C:\Program Files\Vertica Systems\VSQL64


chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshSalesManag_EfDSMSheet\SCRIPTS\renew_DshSalesManag_EfDSMSheet_SalePlanFact.vsql  -A -t -q -o H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_SalePlanFact.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshSalesManag_EfDSMSheet\SCRIPTS\renew_DshSalesManag_EfDSMSheet_PlanStaffAll.vsql  -A -t -q -o H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_PlanStaffAll.vout
chcp 866

if EXIST  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_SalePlanFact.rej goto _end
if EXIST  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_SalePlanFact.exc goto _end
if EXIST  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_PlanStaffAll.rej goto _end
if EXIST  H:\OLAP\DshSalesManag_EfDSMSheet\RUN\renew_DshSalesManag_EfDSMSheet_PlanStaffAll.exc goto _end

copy H:\OLAP\DshSalesManag_EfDSMSheet\null.txt H:\OLAP\DshSalesManag_EfDSMSheet\endgetvrt_DshSalesManag_EfDSMSheet_SalePlanFact.txt H:\OLAP\DshSalesManag_EfDSMSheet\endgetvrt_DshSalesManag_EfDSMSheet_PlanStaffAll.txt

goto _end

:_end

exit 0
