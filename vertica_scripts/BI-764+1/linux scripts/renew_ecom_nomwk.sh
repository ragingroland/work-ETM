#!/bin/bash

now=$(date +"%T")

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik
rm nomwk.flg
# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_nomwk.flg ];
    do
	echo "can't find end_nomwk.flg"
        echo "���� end_nomwk.flg �� ������"
        sleep 100
done
	echo  "Current time: $now"

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_nomenwk.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
	echo "process is running"
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time_nomenwk.log
        echo "start: $(date)" > start_nomenwk.wrk
        echo "������祭�� � ���⨪�"
	echo "connect to vertica"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/nomenklature_week.csv ];
            then
		echo "start vsql"
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_nomenclaturew.vsql -A -q -o /autons/vertica/web_analitik_run/renew_nomenclaturew.vout
        fi
fi

rm start_nomenwk.wrk
echo "2_stop: $(date)" >> time_nomenwk.log
if [ -f /autons/vertica/web_analitik/nomenklature_week.csv ];
   then
       if [ ! -f /autons/vertica/web_analitik_run/nomenklature_week.exc ];
          then
		echo "find exc file"
               rm /autons/vertica/web_analitik/nomenklature_week.csv
               rm end_nomwk.flg
               touch nomwk.flg
       fi
fi
echo "finish script"
exit 0
