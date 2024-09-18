#!/bin/bash

# переход к нужному каталогу
cd /autons/vertica/web_analitik

# проверка наличия флага завершения выгрузки
if [ -f /autons/vertica/web_analitik/end.flg ];
    then
        echo "end.flg присутствует"
    else
        echo "end.flg не найден. ВСЕГО ДОБРОГО!"
        exit 0
fi
# проверка наличия флага уже запущенного процесса (именно вот этого вот всего)
if [ -f /autons/vertica/web_analitik/start.wrk ];
    then
        echo "Процесс уже запущен, выход."
        exit 0
    else
        # так как флага .wrk обнаружено не было, начинается процесс загрузки в базу
        echo "1_start: $(date)" > time.log
        echo "start: $(date)" > start.wrk
        echo "подключение к вертике"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/end_spr.flg];
            then
                if [ -f /autons/vertica/web_analitik/Counter.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_counter.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_counter.vout
                fi
                if [ -f /autons/vertica/web_analitik/Countries.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_countries.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_countries.vout
                fi
                if [ -f /autons/vertica/web_analitik/Regions.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_regions.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_regions.vout
                fi
                if [ -f /autons/vertica/web_analitik/Cities.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_cities.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_cities.vout
                fi
                if [ -f /autons/vertica/web_analitik/TrafficSource.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_trafficsource.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_trafficsource.vout
                fi
                if [ -f /autons/vertica/web_analitik/SearchEngineRoot.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_searchengineroot.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_searchengineroot.vout
                fi
                if [ -f /autons/vertica/web_analitik/TrafficSourceFirstLast.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_trafficsourcefl.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_trafficsourcefl.vout
                fi
                if [ -f /autons/vertica/web_analitik/Status.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_status.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_status.vout
                fi
                if [ -f /autons/vertica/web_analitik/Campaign.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_campaign.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_campaign.vout
                fi
                if [ -f /autons/vertica/web_analitik/Category.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_category.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_category.vout
                fi
                if [ -f /autons/vertica/web_analitik/TypeClient.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_typeclient.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_typeclient.vout
                fi
            else
                echo "Справочники не грузим, т.к нет флажка"
        fi

        if [ -f /autons/vertica/web_analitik/end_fct.flg ];
            then
                if [ -f /autons/vertica/web_analitik/web_analytics.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_webanalytics.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_webanalytics.vout
                fi
                if [ -f /autons/vertica/web_analitik/Nomenclature.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_nomenclature.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_nomenclature.vout
                fi
                if [ -f /autons/vertica/web_analitik/ad_conversion_81.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_adconversion.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_adconversion.vout
                fi
                if [ -f /autons/vertica/web_analitik/direct_indicators.csv ];
                    then
                        vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_directindicators.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_directindicators.vout
                fi
            else
                echo "Факты не грузим, т.к нет флажка"
        fi
fi

rm start.wrk
rm end_spr.flg
echo "2_stop: $(date)" >> time.log
exit 0
