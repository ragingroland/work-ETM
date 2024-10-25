rem загрузка и хранение справочников, выгружаемых из E-Staff с целью реализации BI-дашборда "Рекрутинг" направления HR.
rem BI-844, 845, 846, 848, 756, 822

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

setlocal enableextensions

IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\CandidateStatusMapping.csv exit 0
IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\Rejection.csv exit 0
IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\CandidateStatus.csv exit 0
IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\CandidateStatusBI.csv exit 0
IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\FTE.csv exit 0
IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\RecrDirection.csv exit 0

cd /d H:\OLAP\Estaff_Desc_Data\RUN

del H:\OLAP\Estaff_Desc_Data\endgetfvrt.txt
del H:\OLAP\Estaff_Desc_Data\RUN\*.rej
del H:\OLAP\Estaff_Desc_Data\RUN\*.exc

copy /Y \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\CandidateStatusMapping.csv H:\OLAP\Estaff_Desc_Data\DATA\CandidateStatusMapping.csv /B
copy /Y \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\Rejection.csv H:\OLAP\Estaff_Desc_Data\DATA\Rejection.csv /B
copy /Y \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\CandidateStatus.csv H:\OLAP\Estaff_Desc_Data\DATA\CandidateStatus.csv /B
copy /Y \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\CandidateStatusBI.csv H:\OLAP\Estaff_Desc_Data\DATA\CandidateStatusBI.csv /B
copy /Y \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\FTE.csv H:\OLAP\Estaff_Desc_Data\DATA\FTE.csv /B
copy /Y \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\RecrDirection.csv H:\OLAP\Estaff_Desc_Data\DATA\RecrDirection.csv /B

cd /d H:\OLAP\Estaff_Desc_Data\DATA

for %%f in (*.csv) do (
    echo Converting %%f to %%~nf.vcsv...
    powershell.exe -Command "Get-Content '%%f' | Set-Content -Encoding utf8 '%%~nf.vcsv'"
    powershell -Command "&{ param($Path); $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False); $MyFile = Get-Content $Path; [System.IO.File]::WriteAllLines($Path, $MyFile, $Utf8NoBomEncoding) }" %%~nf.vcsv
)

cd /d H:\OLAP\Estaff_Desc_Data\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Estaff_Desc_Data\SCRIPTS\renew_estaff_candstatus.vsql -A -q -o  H:\OLAP\Estaff_Desc_Data\RUN\renew_estaff_candstatus.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Estaff_Desc_Data\SCRIPTS\renew_estaff_candstatusbi.vsql -A -q -o  H:\OLAP\Estaff_Desc_Data\RUN\renew_estaff_candstatusbi.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Estaff_Desc_Data\SCRIPTS\renew_estaff_candstatusmap.vsql -A -q -o  H:\OLAP\Estaff_Desc_Data\RUN\renew_estaff_candstatusmap.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Estaff_Desc_Data\SCRIPTS\renew_estaff_rejections.vsql -A -q -o  H:\OLAP\Estaff_Desc_Data\RUN\renew_estaff_rejections.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Estaff_Desc_Data\SCRIPTS\renew_Estaff_FTE.vsql -A -q -o  H:\OLAP\Estaff_Desc_Data\RUN\renew_Estaff_FTE.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Estaff_Desc_Data\SCRIPTS\renew_Estaff_RecrDirection.vsql -A -q -o  H:\OLAP\Estaff_Desc_Data\RUN\renew_Estaff_RecrDirection.vout
chcp 866

copy H:\OLAP\Estaff_Desc_Data\null.txt H:\OLAP\Estaff_Desc_Data\endgetfvrt.txt

exit 0
