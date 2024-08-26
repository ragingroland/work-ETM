rem Справочник кластеров, видов, коеффициентов цен и классификатора для скидочных и акционных цен - BI-724

setlocal enableextensions

cd /d H:\OLAP\Params4StockByRgdClust\RUN

del H:\OLAP\Params4StockByRgdClust\endgetfvrt.txt

del H:\OLAP\Params4StockByRgdClust\DATA\*.csv
del H:\OLAP\Params4StockByRgdClust\RUN\*.rej
del H:\OLAP\Params4StockByRgdClust\RUN\*.exc

cd /d H:\OLAP\Params4StockByRgdClust\TEMP

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\Params4StockByRgdClust\RUN\ftp_check_flg.in

if not EXIST H:\OLAP\Params4StockByRgdClust\TEMP\end.flg goto _begget

ftp -n -v -i -s:H:\OLAP\Params4StockByRgdClust\RUN\ftp.in

goto _endget
:_endget

copy /Y H:\OLAP\Params4StockByRgdClust\TEMP\Params4StockByRgdClust.csv H:\OLAP\Params4StockByRgdClust\DATA\Params4StockByRgdClust.csv /B

del H:\OLAP\Params4StockByRgdClust\TEMP\end.flg

cd /d H:\OLAP\Params4StockByRgdClust\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\Params4StockByRgdClust\SCRIPTS\renew_Params4StockByRgdClust.vsql -A -q -o  H:\OLAP\Params4StockByRgdClust\RUN\renew_Params4StockByRgdClust.vout
chcp 866

copy H:\OLAP\Params4StockByRgdClust\null.txt H:\OLAP\Params4StockByRgdClust\endgetfvrt.txt

exit 0
