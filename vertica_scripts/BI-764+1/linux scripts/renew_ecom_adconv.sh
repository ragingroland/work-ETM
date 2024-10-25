#!/bin/bash

# переход к нужному каталогу
cd /autons/vertica/web_analitik

# проверка наличия флага завершения выгрузки
while [ ! -f /autons/vertica/web_analitik/end_adcnv.flg ];
    do
        echo "Файл end_adcnv.flg не найден"
        sleep 100
done

# проверка наличия флага уже запущенного процесса (именно вот этого вот всего)
if [ -f /autons/vertica/web_analitik/start_adcnv.wrk ];
    then
        echo "Процесс уже запущен, выход."
        exit 0
    else
        # так как флага .wrk обнаружено не было, начинается процесс загрузки в базу
        echo "1_start: $(date)" > time_adcnv.log
        echo "start: $(date)" > start_adcnv.wrk
        echo "подключение к вертике"

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
