rem BI-E-com: ࠧࠡ�⪠ ���ਭ ��� ����� "������ ������������" BI-824

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\DshECom_NomenclatureAnls\RUN

del H:\OLAP\DshECom_NomenclatureAnls\endgetfvrt.txt
del H:\OLAP\DshECom_NomenclatureAnls\RUN\nw.flg
del H:\OLAP\DshECom_NomenclatureAnls\RUN\nm.flg
del H:\OLAP\DshECom_NomenclatureAnls\RUN\i81w.flg
del H:\OLAP\DshECom_NomenclatureAnls\RUN\i81m.flg
del H:\OLAP\DshECom_NomenclatureAnls\RUN\i33m.flg
del H:\OLAP\DshECom_NomenclatureAnls\RUN\i33w.flg

:_begget

ping -n 100 relay.etm.spb.ru > nul

ftp -n -v -i -s:H:\OLAP\DshECom_NomenclatureAnls\RUN\ftp_check_flg.in
if not exist H:\OLAP\DshECom_NomenclatureAnls\RUN\nw.flg goto _begget
if not exist H:\OLAP\DshECom_NomenclatureAnls\RUN\nm.flg goto _begget
if not exist H:\OLAP\DshECom_NomenclatureAnls\RUN\i81w.flg goto _begget
if not exist H:\OLAP\DshECom_NomenclatureAnls\RUN\i81m.flg goto _begget
if not exist H:\OLAP\DshECom_NomenclatureAnls\RUN\i33m.flg goto _begget
if not exist H:\OLAP\DshECom_NomenclatureAnls\RUN\i33w.flg goto _begget
if not EXIST I:\common-spr\endgetfvrt.txt goto _begget

goto _end

:_end

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsMnth.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsMnth.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsMnthCL81.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsMnthCL81.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsMnthCL33.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsMnthCL33.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsMnthTrfc.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsMnthTrfc.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsWk.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsWk.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsWkCL81.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsWkCL81.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsWkCL33.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsWkCL33.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsWkTrfc.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsWkTrfc.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsWk_Inact.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsWk_Inact.vout
chcp 866

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_NomenclatureAnls\SCRIPTS\renew_DshECom_NomenclatureAnlsMnth_Inact.vsql -A -q -o  H:\OLAP\DshECom_NomenclatureAnls\RUN\renew_DshECom_NomenclatureAnlsMnth_Inact.vout
chcp 866

copy H:\OLAP\DshECom_NomenclatureAnls\null.txt H:\OLAP\DshECom_NomenclatureAnls\endgetfvrt.txt

exit 0
