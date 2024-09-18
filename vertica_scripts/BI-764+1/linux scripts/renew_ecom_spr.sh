#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik

# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_spr.flg ];
    do
        echo "���� end_spr.flg �� ������"
        sleep 100
done

echo "end_spr.flg ���������"

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_spr.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time_spr.log
        echo "start: $(date)" > start_spr.wrk
        echo "������祭�� � ���⨪�"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
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
        if [ -f /autons/vertica/web_analitik/Campaing.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_campaing.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_campaing.vout
        fi
        if [ -f /autons/vertica/web_analitik/Category.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_category.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_category.vout
        fi
        if [ -f /autons/vertica/web_analitik/TypeClient.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_typeclient.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_typeclient.vout
        fi
        if [ -f /autons/vertica/web_analitik/AdType.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_adtype.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_adtype.vout
        fi
fi

rm start_spr.wrk
rm end_spr.flg
echo "2_stop: $(date)" >> time_spr.log
exit 0
