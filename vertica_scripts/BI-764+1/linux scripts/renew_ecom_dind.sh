#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik

# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_di.flg ];
    do
        echo "���� end_di.flg �� ������"
        sleep 100
done

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_di.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time_di.log
        echo "start: $(date)" > start_di.wrk
        echo "������祭�� � ���⨪�"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/direct_indicators.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_directindicators.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_directindicators.vout
        fi
fi

if [ ! -f /autons/vertica/web_analitik_run/vertica_scripts/direct_indicators.rej ];
    then
        rm /autons/vertica/web_analitik/direct_indicators.csv
fi

rm start_di.wrk
rm end_di.flg
echo "2_stop: $(date)" >> time_di.log
exit 0
