rem витрины по ДСЦ для дашборда УП

setlocal enableextensions

cd /d H:\OLAP\DshSalesManag_LongTerm\RUN

del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_DivMnth.vout
del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_DivMnth.rej
del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_DivMnth.exc
del  H:\OLAP\DshSalesManag_LongTerm\endgetvrt_DshSalesManag_LongTerm_DivMnth.txt

del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_DivSpecMnth.vout
del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_DivSpecMnth.rej
del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_DivSpecMnth.exc
del  H:\OLAP\DshSalesManag_LongTerm\endgetvrt_DshSalesManag_LongTerm_DivSpecMnth.txt

del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_TotDivMnth.vout
del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_TotDivMnth.rej
del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_TotDivMnth.exc
del  H:\OLAP\DshSalesManag_LongTerm\endgetvrt_DshSalesManag_LongTerm_TotDivMnth.txt

del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_TotDivSpecMnth.vout
del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_TotDivSpecMnth.rej
del  H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_TotDivSpecMnth.exc
del  H:\OLAP\DshSalesManag_LongTerm\endgetvrt_DshSalesManag_LongTerm_TotDivSpecMnth.txt

:_beg

ping -n 100 relay.etm.spb.ru > nul

if not EXIST I:\common-spr\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\GrpLegEntPersForCRM\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\CBStatTrader\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\LongTermGoalDiv_LegEnt\endgetfvrt.txt goto _beg
if not EXIST H:\OLAP\LongTermGoalTot_LegEnt\endgetfvrt.txt goto _beg

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshSalesManag_LongTerm\SCRIPTS\renew_DshSalesManag_LongTerm_DivMnth.vsql  -A -q -o H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_DivMnth.vout
chcp 866 

copy H:\OLAP\DshSalesManag_LongTerm\null.txt H:\OLAP\DshSalesManag_LongTerm\endgetvrt_DshSalesManag_LongTerm_DivMnth.txt

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshSalesManag_LongTerm\SCRIPTS\renew_DshSalesManag_LongTerm_DivSpecMnth.vsql  -A -q -o H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_DivSpecMnth.vout
chcp 866 

copy H:\OLAP\DshSalesManag_LongTerm\null.txt H:\OLAP\DshSalesManag_LongTerm\endgetvrt_DshSalesManag_LongTerm_DivSpecMnth.txt

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshSalesManag_LongTerm\SCRIPTS\renew_DshSalesManag_LongTerm_TotDivMnth.vsql  -A -q -o H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_TotDivMnth.vout
chcp 866 

copy H:\OLAP\DshSalesManag_LongTerm\null.txt H:\OLAP\DshSalesManag_LongTerm\endgetvrt_DshSalesManag_LongTerm_TotDivMnth.txt

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshSalesManag_LongTerm\SCRIPTS\renew_DshSalesManag_LongTerm_TotDivSpecMnth.vsql  -A -q -o H:\OLAP\DshSalesManag_LongTerm\RUN\renew_DshSalesManag_LongTerm_TotDivSpecMnth.vout
chcp 866 

copy H:\OLAP\DshSalesManag_LongTerm\null.txt H:\OLAP\DshSalesManag_LongTerm\endgetvrt_DshSalesManag_LongTerm_TotDivSpecMnth.txt

goto _end

:_end

exit 0