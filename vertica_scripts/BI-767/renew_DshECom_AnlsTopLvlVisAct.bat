rem BI-E-com: ࠧࠡ�⪠ ���ਭ ��� ����� "������ ���孥�஢����� ��⨢���� ����⥫��" BI-767

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\DshECom_AnlsTopLvlVisAct\RUN

del H:\OLAP\DshECom_AnlsTopLvlVisAct\endgetfvrt.txt
del H:\OLAP\DshECom_AnlsTopLvlVisAct\RUN\wa.flg

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\DshECom_AnlsTopLvlVisAct\RUN\ftp_check_flg.in
if not exist H:\OLAP\DshECom_AnlsTopLvlVisAct\RUN\wa.flg goto _begget
if not EXIST I:\common-spr\endgetfvrt.txt goto _begget

goto _endget
:_endget

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_AnlsTopLvlVisAct\SCRIPTS\renew_DshECom_AnlsTopLvlVisAct.vsql -A -q -o  H:\OLAP\DshECom_AnlsTopLvlVisAct\RUN\renew_DshECom_AnlsTopLvlVisAct.vout
chcp 866

copy H:\OLAP\DshECom_AnlsTopLvlVisAct\null.txt H:\OLAP\DshECom_AnlsTopLvlVisAct\endgetfvrt.txt

exit 0
