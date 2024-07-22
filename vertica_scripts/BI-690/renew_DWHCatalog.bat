rem Создание справочника по таблицам Vertica BI-690

setlocal enableextensions

cd /d H:\OLAP\DWHCatalog\RUN

del  H:\OLAP\DWHCatalog\RUN\renew_DWHCatalog.vout
del  H:\OLAP\DWHCatalog\endgetfvrt_DWHCatalog.txt

:_beg

path=%path%;C:\Program Files\Vertica Systems\VSQL64

chcp 65001
vsql.exe -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f H:\OLAP\DWHCatalog\SCRIPTS\renew_DWHCatalog.vsql  -A -q -o H:\OLAP\DWHCatalog\RUN\renew_DWHCatalog.vout
chcp 866 

copy H:\OLAP\DWHCatalog\null.txt H:\OLAP\DWHCatalog\endgetfvrt_DWHCatalog.txt

goto _end

:_end

exit 0