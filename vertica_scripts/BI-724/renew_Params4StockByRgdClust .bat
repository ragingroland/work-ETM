rem Справочник кластеров, видов, коеффициентов цен и классификатора для скидочных и акционных цен - BI-724

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

setlocal enableextensions

IF NOT EXIST \\cpfs1.etm.corp\DataLoadVertica\Params4StockByRgdClust\Params4StockByRgdClust.csv exit 0

cd /d H:\OLAP\Params4StockByRgdClust\RUN

del H:\OLAP\Params4StockByRgdClust\endgetfvrt.txt

del H:\OLAP\Params4StockByRgdClust\DATA\*.csv
del H:\OLAP\Params4StockByRgdClust\RUN\*.rej
del H:\OLAP\Params4StockByRgdClust\RUN\*.exc



copy /Y \\cpfs1.etm.corp\DataLoadVertica\Params4StockByRgdClust\Params4StockByRgdClust.csv H:\OLAP\Params4StockByRgdClust\DATA\Params4StockByRgdClust.csv /B

powershell.exe "Get-Content H:\OLAP\Params4StockByRgdClust\DATA\Params4StockByRgdClust.csv  | Set-Content -Encoding utf8 H:\OLAP\Params4StockByRgdClust\DATA\Params4StockByRgdClust.vcsv"
powershell -Command "&{ param($Path); $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False); $MyFile = Get-Content $Path; [System.IO.File]::WriteAllLines($Path, $MyFile, $Utf8NoBomEncoding) }" H:\OLAP\Params4StockByRgdClust\DATA\Params4StockByRgdClust.vcsv



path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Params4StockByRgdClust\SCRIPTS\renew_Params4StockByRgdClust.vsql -A -q -o  H:\OLAP\Params4StockByRgdClust\RUN\renew_Params4StockByRgdClust.vout
chcp 866

copy H:\OLAP\Params4StockByRgdClust\null.txt H:\OLAP\Params4StockByRgdClust\endgetfvrt.txt

exit 0
