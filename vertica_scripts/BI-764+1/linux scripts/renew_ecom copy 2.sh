#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik

# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
if [ -f /autons/vertica/web_analitik/end.flg ];
    then
        echo "end.flg ���������"
    else
        echo "end.flg �� ������. ����� �������!"
        exit 0
fi
# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time.log
        echo "start: $(date)" > start.wrk
        echo "������祭�� � ���⨪�"

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
                echo "��ࠢ�筨�� �� ��㧨�, �.� ��� 䫠���"
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
                echo "����� �� ��㧨�, �.� ��� 䫠���"
        fi
fi

rm start.wrk
rm end_spr.flg
echo "2_stop: $(date)" >> time.log
exit 0
