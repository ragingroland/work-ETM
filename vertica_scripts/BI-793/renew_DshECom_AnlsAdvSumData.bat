rem BI-E-com: ࠧࠡ�⪠ ���ਭ ��� ����� "������ ���孥�஢����� ��⨢���� ����⥫��" BI-767

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\DshECom_AnlsAdvSumData\RUN

del H:\OLAP\DshECom_AnlsAdvSumData\endgetfvrt.txt

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\DshECom_AnlsAdvSumData\SCRIPTS\renew_DshECom_AnlsAdvSumData.vsql -A -q -o  H:\OLAP\DshECom_AnlsAdvSumData\RUN\renew_DshECom_AnlsAdvSumData.vout
chcp 866

copy H:\OLAP\DshECom_AnlsAdvSumData\null.txt H:\OLAP\DshECom_AnlsAdvSumData\endgetfvrt.txt

exit 0
