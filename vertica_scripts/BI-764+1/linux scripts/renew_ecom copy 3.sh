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
