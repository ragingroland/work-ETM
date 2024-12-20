#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik
rm nact81_mnth.flg
# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_inact81_mnth.flg ];
    do
        echo "���� end_inact81_mnth.flg �� ������"
        sleep 100
done

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_inact81_mnth.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time_inactive81mnth.log
        echo "start: $(date)" > start_inact81_mnth.wrk
        echo "������祭�� � ���⨪�"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/inactive_81_month.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_inactive81mnth.vsql -A -q -o /autons/vertica/web_analitik_run/renew_inactive81mnth.vout
        fi
fi

if [ ! -f /autons/vertica/web_analitik_run/vertica_scripts/inactive_81_month.rej ];
    then
        rm /autons/vertica/web_analitik/inactive_81_month.csv
        rm end_inact81_mnth.flg
        touch nact81_mnth.flg
fi

rm start_inact81_mnth.wrk
echo "2_stop: $(date)" >> time_inactive81mnth.log
exit 0
