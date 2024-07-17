rem Наполнение витрин для дашборда "Уровень принятия решения за 24 часа" (Elma)

setlocal enableextensions

cd /d H:\OLAP\DshLogistManag_AssessQltCompl\RUN

del  H:\OLAP\DshLogistManag_AssessQltCompl\RUN\renew_DshLogistManag_AssessQltCompl.vout
del  H:\OLAP\DshLogistManag_AssessQltCompl\RUN\renew_DshLogistManag_AssessQltCompl.rej
del  H:\OLAP\DshLogistManag_AssessQltCompl\RUN\renew_DshLogistManag_AssessQltCompl.exc
del  H:\OLAP\DshLogistManag_AssessQltCompl\endgetvrt_DshLogistManag_AssessQltCompl.txt

:_beg

ping -n 100 relay.etm.spb.ru > nul

if not EXIST I:\Elma_Complaints\endgetfvrt.txt goto _beg

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshLogistManag_AssessQltCompl\SCRIPTS\renew_DshLogistManag_AssessQltCompl.vsql  -A -q -o H:\OLAP\DshLogistManag_AssessQltCompl\RUN\renew_DshLogistManag_AssessQltCompl.vout
chcp 866 

copy H:\OLAP\DshLogistManag_AssessQltCompl\null.txt H:\OLAP\DshLogistManag_AssessQltCompl\endgetvrt_DshLogistManag_AssessQltCompl.txt

goto _end

:_end

exit 0