rem BI-CSI: организовать хранение таблицы фактов из RocketData в Vertica BI-855

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

setlocal enableextensions

IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\Elma_ServiceQuality_Claims\ClaimsMark.csv exit 0

cd /d H:\OLAP\CSI_RDMapFdbk\RUN

del H:\OLAP\CSI_RDMapFdbk\endgetfvrt.txt
del H:\OLAP\CSI_RDMapFdbk\RUN\*.rej
del H:\OLAP\CSI_RDMapFdbk\RUN\*.exc

copy /Y \\cpfs1.etm.corp\DataLoadVertica\Elma_ServiceQuality_Claims\ClaimsMark.csv H:\OLAP\CSI_RDMapFdbk\DATA\ClaimsMark.csv /B

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\CSI_RDMapFdbk\SCRIPTS\renew_CSI_RDMapFdbk.vsql -A -q -o  H:\OLAP\CSI_RDMapFdbk\RUN\renew_CSI_RDMapFdbk.vout
chcp 866

copy H:\OLAP\CSI_RDMapFdbk\null.txt H:\OLAP\CSI_RDMapFdbk\endgetfvrt.txt

exit 0
