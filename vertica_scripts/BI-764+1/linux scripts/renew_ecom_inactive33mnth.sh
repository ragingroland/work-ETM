#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik

# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_inact33_mnth.flg ];
    do
        echo "���� end_inact33_mnth.flg �� ������"
        sleep 100
done

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_inact33mnth.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time_inactive33mnth.log
        echo "start: $(date)" > start_inact33mnth.wrk
        echo "������祭�� � ���⨪�"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/inactive_33_month.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_inactive33mnth.vsql -A -q -o /autons/vertica/web_analitik_run/renew_inactive33mnth.vout
        fi
fi

if [ ! -f /autons/vertica/web_analitik_run/vertica_scripts/inactive_33_month.rej ];
    then
        rm /autons/vertica/web_analitik/inactive_33_month.csv
fi

rm start_inact33mnth.wrk
rm end_inact33_mnth.flg
echo "2_stop: $(date)" >> time_inactive33mnth.log
exit 0
