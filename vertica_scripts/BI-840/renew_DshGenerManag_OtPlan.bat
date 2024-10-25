rem Витрина с планами для генерального дашборда BI-840

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

setlocal enableextensions

cd /d H:\OLAP\DshGenerManag_OtPlan\RUN

del  H:\OLAP\DshGenerManag_OtPlan\RUN\renew_DshGenerManag_OtPlan.vout
del  H:\OLAP\DshGenerManag_OtPlan\endgetfvrt.txt

:_beg
ping -n 100 relay.etm.spb.ru > nul

if not EXIST I:\common-spr\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\OpPlSumCliTrnDtl_OperRes\endgetfvrt.txt goto _beg
if not EXIST I:\go_common\endgetfvrt.txt goto _beg
if not EXIST I:\itogi_common\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\CCB_CliTrn\endgetfvrt_ccb.txt goto _beg
if not EXIST H:\OLAP\CCB_Ot\endgetfvrt_ccb.txt goto _beg
if not EXIST H:\OLAP\ArrivalCliFunds\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\BudgIncome\endgetfvrt_BudgIncomeToPlan.txt goto _beg
if not EXIST H:\OLAP\BudgExpenses\endgetfvrt_BudgExpensesFact.txt goto _beg
if not EXIST H:\OLAP\BudgExpenses\endgetfvrt_BudgExpensesPlan.txt goto _beg
if not EXIST H:\OLAP\CliTrnBudgPlan\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\RgdDivisDprt\endgetfvrt.txt goto _beg

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshGenerManag_OtPlan\SCRIPTS\renew_DshGenerManag_OtPlan.vsql  -A -t -q -o H:\OLAP\DshGenerManag_OtPlan\RUN\renew_DshGenerManag_OtPlan.vout
chcp 866

copy H:\OLAP\DshGenerManag_OtPlan\null.txt H:\OLAP\DshGenerManag_OtPlan\endgetfvrt.txt

goto _end

:_end

exit 0
