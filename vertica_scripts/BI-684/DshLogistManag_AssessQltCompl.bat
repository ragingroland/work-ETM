rem ?????????? ???? ??? ???? "????? ????? ???? ?? 24 ??" (Elma)

setlocal enableextensions

cd /d H:\OLAP\DshLogistManag_AssessQltCompl\RUN

del  H:\OLAP\DshLogistManag_AssessQltCompl\RUN\renew_DshLogistManag_AssessQltCompl_rdc.vout
del  H:\OLAP\DshLogistManag_AssessQltCompl\RUN\renew_DshLogistManag_AssessQltCompl_rdc.rej
del  H:\OLAP\DshLogistManag_AssessQltCompl\RUN\renew_DshLogistManag_AssessQltCompl_rdc.exc
del  H:\OLAP\DshLogistManag_AssessQltCompl\endgetfvrt_DshLogistManag_AssessQltCompl_rdc.txt

:_beg

ping -n 100 relay.etm.spb.ru > nul
 
if not EXIST H:\OLAP\Elma_Complaints\null.txt H:\OLAP\Elma_Complaints\endgetfvrt.txt goto _beg

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DshLogistManag_AssessQltCompl\SCRIPTS\renew_DshLogistManag_AssessQltCompl_rdc.vsql  -A -q -o H:\OLAP\DshLogistManag_AssessQltCompl\RUN\renew_DshLogistManag_AssessQltCompl_rdc.vout
chcp 866 

copy H:\OLAP\DshLogistManag_AssessQltCompl\null.txt H:\OLAP\DshLogistManag_AssessQltCompl\endgetfvrt_DshLogistManag_AssessQltCompl_rdc.txt

goto _end

:_end

exit 0