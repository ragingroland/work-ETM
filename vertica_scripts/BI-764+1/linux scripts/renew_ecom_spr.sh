#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik

# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_spr.flg ];
    do
        echo "���� end_spr.flg �� ������" > sleep_spr.100
        sleep 100
done

echo "end_spr.flg ���������"

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_spr.wrk ];
    then
        echo "����� 㦥 ����饭, ��室." >> time_spr.log
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" >> time_spr.log
        echo "start: $(date)" > start_spr.wrk
        echo "������祭�� � ���⨪�" >> start_spr.wrk

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/Counter.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_counter.vsql -A -q -o /autons/vertica/web_analitik_run/renew_counter.vout
        fi
        if [ -f /autons/vertica/web_analitik/Countries.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_countries.vsql -A -q -o /autons/vertica/web_analitik_run/renew_countries.vout
        fi
        if [ -f /autons/vertica/web_analitik/Regions.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_regions.vsql -A -q -o /autons/vertica/web_analitik_run/renew_regions.vout
        fi
        if [ -f /autons/vertica/web_analitik/Cities.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_cities.vsql -A -q -o /autons/vertica/web_analitik_run/renew_cities.vout
        fi
        if [ -f /autons/vertica/web_analitik/TrafficSource.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_trafficsource.vsql -A -q -o /autons/vertica/web_analitik_run/renew_trafficsource.vout
        fi
        if [ -f /autons/vertica/web_analitik/SearchEngineRoot.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_searchengineroot.vsql -A -q -o /autons/vertica/web_analitik_run/renew_searchengineroot.vout
        fi
        if [ -f /autons/vertica/web_analitik/TrafficSourceFirstLast.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_trafficsourcefl.vsql -A -q -o /autons/vertica/web_analitik_run/renew_trafficsourcefl.vout
        fi
        if [ -f /autons/vertica/web_analitik/Status.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_status.vsql -A -q -o /autons/vertica/web_analitik_run/renew_status.vout
        fi
        if [ -f /autons/vertica/web_analitik/Campaing.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_campaing.vsql -A -q -o /autons/vertica/web_analitik_run/renew_campaing.vout
        fi
        if [ -f /autons/vertica/web_analitik/Category.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_category.vsql -A -q -o /autons/vertica/web_analitik_run/renew_category.vout
        fi
        if [ -f /autons/vertica/web_analitik/TypeClient.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_typeclient.vsql -A -q -o /autons/vertica/web_analitik_run/renew_typeclient.vout
        fi
        if [ -f /autons/vertica/web_analitik/AdType.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_adtype.vsql -A -q -o /autons/vertica/web_analitik_run/renew_adtype.vout
        fi
fi

rm start_spr.wrk
echo "2_stop: $(date)" >> time_spr.log
if [ -f /autons/vertica/web_analitik/time_spr.log ];
    then
        if [ ! -f /autons/vertica/web_analitik_run/counter.exc ];
            then
                rm /autons/vertica/web_analitik/Counter.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/countries.exc ];
            then
                rm /autons/vertica/web_analitik/Countries.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/regions.exc ];
            then
                rm /autons/vertica/web_analitik/Regions.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/cities.exc ];
            then
                rm /autons/vertica/web_analitik/Cities.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/TrafficSource.exc ];
            then
                rm /autons/vertica/web_analitik/TrafficSource.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/SearchEngineRoot.exc ];
            then
                rm /autons/vertica/web_analitik/SearchEngineRoot.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/TrafficSourceFirstLast.exc ];
            then
                rm /autons/vertica/web_analitik/TrafficSourceFirstLast.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/Status.exc ];
            then
                rm /autons/vertica/web_analitik/Status.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/Campaing.exc ];
            then
                rm /autons/vertica/web_analitik/Campaing.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/Category.exc ];
            then
                rm /autons/vertica/web_analitik/Category.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/TypeClient.exc ];
            then
                rm /autons/vertica/web_analitik/TypeClient.csv
        fi
        if [ ! -f /autons/vertica/web_analitik_run/adtype.exc ];
            then
                rm /autons/vertica/web_analitik/AdType.csv
        fi
fi

directory="/autons/vertica/web_analitik_run"
file_pattern="*.exc"
# �஢�ઠ ������ 䠩���
found_files=$(find "$directory" -name "$file_pattern" -print)
# �᫨ 䠩�� �������
if [ -n "$found_files" ];
    then
        exit 0
    else
        rm end_spr.flg
fi
exit 0
