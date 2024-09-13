#!/bin/bash
#key=`date`

# /usr/bin/mesg y
# TERM=ansi; export TERM
# PROPATH=/ns3/prog12:/ns3/prog12.wrk:/ns3/prog12/olap:/ns3u/prog12:.; export PROPATH
# DLC=/usr/dlc; export DLC
# PATH=$DLC/bin:$PATH:.; export PATH         ^<- зачем?

# Менять путь к папке тут
NAME=vertica/web_analitik


cd /autons/$NAME

if [ -f /autons/$NAME/end.flg ];
then
    echo "end.flg is present"
else
    echo "end.flg is abscent"
    exit 0
fi


if [ -f /autons/$NAME/*.wrk ]
then
echo "Process is already running"
echo run proc > testtttt
exit 9
else
rm *.vout
rm *.rej
rm *.exc
rm *.log
rm *.lg

echo "1_start: $(date)" > time.log

echo "start: $(date)" > start.wrk

# cp o-price-$price.par o-price-xx.par
# $DLC/bin/_progres -pf /autons/$NAME/auto.pf -T $HOME  <- зачем?

echo "connect vertica"

PATH=/opt/vertica/bin:$PATH:.; export PATH
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_counter.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_counter.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_countries.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_countries.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_regions.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_regions.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_cities.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_cities.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_trafficsource.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_trafficsource.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_searchengineroot.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_searchengineroot.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_trafficsourcefl.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_trafficsourcefl.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_status.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_status.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_campaign.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_campaign.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_category.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_category.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_webanalytics.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_webanalytics.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_nomenclature.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_nomenclature.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_adconversion.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_adconversion.vout
vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/$NAME/vertica_scripts/renew_directindicators.vsql -A -q -o /autons/$NAME/vertica_scripts/renew_directindicators.vout

rm start.wrk
echo "2_stop: $(date)" >> time.log
fi
rm end.flg
exit 0
