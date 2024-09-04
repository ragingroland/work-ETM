rem табличка настройки мониторинга конкурентов по регионам BI-622

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0
IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\Rules37OldNew\Rules37OldToAct.csv exit 0

setlocal enableextensions

cd /d H:\OLAP\Rules37OldToAct\RUN

del H:\OLAP\Rules37OldToAct\endgetfvrt.txt

del H:\OLAP\Rules37OldToAct\DATA\*.csv
del H:\OLAP\Rules37OldToAct\DATA\*.vcsv
del H:\OLAP\Rules37OldToAct\RUN\*.rej
del H:\OLAP\Rules37OldToAct\RUN\*.exc
del H:\OLAP\Rules37OldToAct\RUN\*.vout

cd /d H:\OLAP\Rules37OldToAct\DATA

:_beg

ping -n 100 relay.etm.spb.ru >nul

move \\cpfs1.etm.corp\DataLoadVertica\Rules37OldNew\Rules37OldToAct.csv H:\OLAP\Rules37OldToAct\DATA\Rules37OldToAct.csv

for %%f in (*.csv) do (
    echo Converting %%f to %%~nf.vcsv...
    powershell.exe -Command "Get-Content '%%f' | Set-Content -Encoding utf8 '%%~nf.vcsv'"
    powershell -Command "&{ param($Path); $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False); $MyFile = Get-Content $Path; [System.IO.File]::WriteAllLines($Path, $MyFile, $Utf8NoBomEncoding) }" %%~nf.vcsv
)

goto _end

:_end

cd /d H:\OLAP\Rules37OldToAct\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Rules37OldToAct\SCRIPTS\renew_Rules37OldToAct.vsql -A -q -o  H:\OLAP\Rules37OldToAct\RUN\renew_Rules37OldToAct.vout
chcp 866

rem IF EXIST H:\OLAP\Rules37OldToAct\RUN\Rules37OldToAct.rej H:\OLAP\Rules37OldToAct\RUN\postie.exe -gmt -host:relay.etm.spb.ru -tolist:H:\OLAP\Rules37OldToAct\RUN\sendme_err_src.file -from:base@etm.spb.ru -s:"Произошли ошибки загрузки из Rules37OldToAct.csv" -a:Rules37OldToAct.rej -charset:windows-1251

copy H:\OLAP\Rules37OldToAct\null.txt H:\OLAP\Rules37OldToAct\endgetfvrt.txt

exit 0
