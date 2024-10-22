rem BI-Рекрутинг: загрузка и хранение VacancyStatus - BI-836

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

setlocal enableextensions

IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\VacancyStatus.csv exit 0

cd /d H:\OLAP\Estaff_VacancyStatus\RUN

del H:\OLAP\Estaff_VacancyStatus\endgetfvrt.txt

del H:\OLAP\Estaff_VacancyStatus\DATA\*.csv
del H:\OLAP\Estaff_VacancyStatus\RUN\*.rej
del H:\OLAP\Estaff_VacancyStatus\RUN\*.exc

copy /Y \\cpfs1.etm.corp\DataLoadVertica\HR_Estaff_ReferBooks\VacancyStatus.csv H:\OLAP\Estaff_VacancyStatus\DATA\VacancyStatus.csv /B

powershell.exe "Get-Content H:\OLAP\Estaff_VacancyStatus\DATA\VacancyStatus.csv  | Set-Content -Encoding utf8 H:\OLAP\Estaff_VacancyStatus\DATA\VacancyStatus.vcsv"
powershell -Command "&{ param($Path); $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False); $MyFile = Get-Content $Path; [System.IO.File]::WriteAllLines($Path, $MyFile, $Utf8NoBomEncoding) }" H:\OLAP\Estaff_VacancyStatus\DATA\VacancyStatus.vcsv

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Estaff_VacancyStatus\SCRIPTS\renew_Estaff_VacancyStatus.vsql -A -q -o  H:\OLAP\Estaff_VacancyStatus\RUN\renew_Estaff_VacancyStatus.vout
chcp 866

copy H:\OLAP\Estaff_VacancyStatus\null.txt H:\OLAP\Estaff_VacancyStatus\endgetfvrt.txt

exit 0
