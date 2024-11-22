#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik
rm wbanl.flg
# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_wbanl.flg ];
    do
        echo "���� end_wbanl.flg �� ������"
        sleep 100
done

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_wa.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time_wa.log
        echo "start: $(date)" > start_wa.wrk
        echo "������祭�� � ���⨪�"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/dm_web_analytics.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_webanalytics.vsql -A -q -o /autons/vertica/web_analitik_run/renew_webanalytics.vout
        fi
fi

rm start_wa.wrk
echo "2_stop: $(date)" >> time_wa.log
if [ -f /autons/vertica/web_analitik/dm_web_analytics.csv ];
   then
       if [ ! -f /autons/vertica/web_analitik_run/web_analytics.exc ];
          then
               rm /autons/vertica/web_analitik/dm_web_analytics.csv
               rm end_wbanl.flg
               touch wbanl.flg
       fi
fi
exit 0
