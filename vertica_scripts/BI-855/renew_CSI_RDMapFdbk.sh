#!/bin/bash
log="/autons/rocketdata/logging.log"
# переход к нужному каталогу
cd /autons/rocketdata
if [ -f err_flag ];
    then
        rm err_flag
fi
if [ -f finish_flag ];
    then
        rm finish_flag
fi
# проверка наличия флага уже запущенного процесса (именно вот этого вот всего)
if [ -f /autons/rocketdata/start_rd.wrk ];
    then
        echo "Процесс уже запущен, выход."
        exit 0
    else
        # так как флага .wrk обнаружено не было, начинается процесс загрузки в базу
        echo "1_start: $(date)" > time_rd.log
        echo "start: $(date)" > start_rd.wrk
        echo "подключение к вертике"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/rocketdata/CSI_RDMapFdbk.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/rocketdata/renew_CSI_RDMapFdbk.vsql -A -q -o /autons/rocketdata/renew_CSI_RDMapFdbk.vout
        fi
fi

rm start_rd.wrk
echo "2_stop: $(date)" >> time_rd.log
if [ -f /autons/rocketdata/CSI_RDMapFdbk.csv ];
    then
        if [ ! -f /autons/rocketdata/CSI_RDMapFdbk.exc ];
            then
                echo "ошибок не возникло"
                echo "$log" > /autons/rocketdata/finish_flag
                exit 0
            else
                echo "возникла ошибка"
                cat /autons/rocketdata/CSI_RDMapFdbk.exc > /autons/rocketdata/err_flag
                echo "$log" >> /autons/rocketdata/err_flag
                exit 1
        fi
fi


