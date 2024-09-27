#!/bin/bash

# ���室 � �㦭��� ��⠫���
cd /autons/vertica/web_analitik

# �஢�ઠ ������ 䫠�� �����襭�� ���㧪�
while [ ! -f /autons/vertica/web_analitik/end_nommnth.flg ];
    do
        echo "���� end_nommnth.flg �� ������"
        sleep 100
done

# �஢�ઠ ������ 䫠�� 㦥 ����饭���� ����� (������ ��� �⮣� ��� �ᥣ�)
if [ -f /autons/vertica/web_analitik/start_nomenm.wrk ];
    then
        echo "����� 㦥 ����饭, ��室."
        exit 0
    else
        # ⠪ ��� 䫠�� .wrk �����㦥�� �� �뫮, ��稭����� ����� ����㧪� � ����
        echo "1_start: $(date)" > time_nomenm.log
        echo "start: $(date)" > start_nomenm.wrk
        echo "������祭�� � ���⨪�"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/nomenklature_month.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_nomenclaturem.vsql -A -q -o /autons/vertica/web_analitik_run/renew_nomenclaturem.vout
        fi
fi

rm start_nomenm.wrk
rm end_nommnth.flg
echo "2_stop: $(date)" >> time_nomenm.log
if [ -f /autons/vertica/web_analitik/nomenklature_month.csv ];
   then
       if [ ! -f /autons/vertica/web_analitik_run/nomenklature_month.exc ];
          then
               rm /autons/vertica/web_analitik/nomenklature_month.csv
       fi
fi
exit 0
