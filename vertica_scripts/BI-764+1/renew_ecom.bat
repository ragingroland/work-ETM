rem ‡ £àã§ª  ClickHouse -> Veritca - BI-764 BI-765

setlocal enableextensions

IF EXIST H:\OLAP\MoveJobs\movejobs.txt exit 0

cd /d H:\OLAP\ECom_ClkHse-Vertica\RUN

del H:\OLAP\ECom_ClkHse-Vertica\endgetfvrt.txt

del H:\OLAP\ECom_ClkHse-Vertica\DATA\*.csv
del H:\OLAP\ECom_ClkHse-Vertica\RUN\*.rej
del H:\OLAP\ECom_ClkHse-Vertica\RUN\*.exc

cd /d H:\OLAP\ECom_ClkHse-Vertica\TEMP

:_begget

ping -n 100 relay.etm.spb.ru >nul

ftp -n -v -i -s:H:\OLAP\ECom_ClkHse-Vertica\RUN\ftp_check_flg.in

if not EXIST H:\OLAP\ECom_ClkHse-Vertica\TEMP\end.flg goto _begget

ftp -n -v -i -s:H:\OLAP\ECom_ClkHse-Vertica\RUN\ftp.in

goto _endget
:_endget

copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\Counter.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\Counter.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\‘ountries.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\‘ountries.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\Regions.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\Regions.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\Cities.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\Cities.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\TrafficSource.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\TrafficSource.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\SearchEngineRoot.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\SearchEngineRoot.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\TrafficSourceFirstLast.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\TrafficSourceFirstLast.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\Status.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\Status.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\Campaign.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\Campaign.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\Category.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\Category.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\web_analytics.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\web_analytics.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\Nomenclature.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\Nomenclature.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\ad_conversion_81.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\ad_conversion_81.csv /B
copy /Y H:\OLAP\ECom_ClkHse-Vertica\TEMP\direct_indicators.csv H:\OLAP\ECom_ClkHse-Vertica\DATA\direct_indicators.csv /B

del H:\OLAP\ECom_ClkHse-Vertica\TEMP\end.flg

cd /d H:\OLAP\ECom_ClkHse-Vertica\RUN

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_counter.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_counter.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_countries.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_countries.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_regions.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_regions.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_cities.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_cities.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_trafficsource.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_trafficsource.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_searchengineroot.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_searchengineroot.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_trafficsourcefl.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_trafficsourcefl.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_status.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_status.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_campaign.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_campaign.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_category.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_category.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_webanalytics.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_webanalytics.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_nomenclature.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_nomenclature.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_adconversion.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_adconversion.vout
chcp 866
chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C  -f H:\OLAP\ECom_ClkHse-Vertica\SCRIPTS\renew_directindicators.vsql -A -q -o  H:\OLAP\ECom_ClkHse-Vertica\RUN\renew_directindicators.vout
chcp 866

copy H:\OLAP\ECom_ClkHse-Vertica\null.txt H:\OLAP\ECom_ClkHse-Vertica\endgetfvrt.txt

exit 0
