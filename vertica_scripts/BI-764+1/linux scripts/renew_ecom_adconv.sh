#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik

# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_adcnv.flg ];
    do
        echo "���� end_adcnv.flg �� ������"
        sleep 100
done

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_adcnv.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time_adcnv.log
        echo "start: $(date)" > start_adcnv.wrk
        echo "������祭�� � ���⨪�"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/ad_conversion_81.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_adconversion.vsql -A -q -o /autons/vertica/web_analitik_run/renew_adconversion.vout
        fi
fi

rm start_adcnv.wrk
echo "2_stop: $(date)" >> time_adcnv.log
if [ -f /autons/vertica/web_analitik/ad_conversion_81.csv ];
   then
   if [ ! -f /autons/vertica/web_analitik_run/ad_conversion_81.exc ];
      then
           rm /autons/vertica/web_analitik/ad_conversion_81.csv
           rm end_adcnv.flg
   fi
fi
exit 0
