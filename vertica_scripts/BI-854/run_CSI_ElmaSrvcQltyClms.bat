rem BI-CSI: организовать хранение таблицы фактов из ELMA (жалобы) в Vertica BI-854

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

setlocal enableextensions

IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\Elma_ServiceQuality_Claims\ClaimsMark.csv exit 0
IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\Elma_ServiceQuality_Claims\ServiceQualityMark.csv exit 0

cd /d H:\OLAP\CSI_ElmaSrvcQltyClms\RUN

del H:\OLAP\CSI_ElmaSrvcQltyClms\endgetfvrt.txt
del H:\OLAP\CSI_ElmaSrvcQltyClms\RUN\*.rej
del H:\OLAP\CSI_ElmaSrvcQltyClms\RUN\*.exc

copy /Y \\cpfs1.etm.corp\DataLoadVertica\Elma_ServiceQuality_Claims\ClaimsMark.csv H:\OLAP\CSI_ElmaSrvcQltyClms\DATA\ClaimsMark.csv /B
copy /Y \\cpfs1.etm.corp\DataLoadVertica\Elma_ServiceQuality_Claims\ServiceQualityMark.csv H:\OLAP\CSI_ElmaSrvcQltyClms\DATA\ServiceQualityMark.csv /B

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\CSI_ElmaSrvcQltyClms\SCRIPTS\renew_CSI_ElmaClaims.vsql -A -q -o  H:\OLAP\CSI_ElmaSrvcQltyClms\RUN\renew_CSI_ElmaClaims.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\CSI_ElmaSrvcQltyClms\SCRIPTS\renew_CSI_ElmaSrvcQlty.vsql -A -q -o  H:\OLAP\CSI_ElmaSrvcQltyClms\RUN\renew_CSI_ElmaSrvcQlty.vout
chcp 866

copy H:\OLAP\CSI_ElmaSrvcQltyClms\null.txt H:\OLAP\CSI_ElmaSrvcQltyClms\endgetfvrt.txt

exit 0
