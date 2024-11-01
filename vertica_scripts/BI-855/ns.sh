#key=`date`
#/usr/bin/mesg y
TERM=ansi; export TERM
PROPATH=/ns3/prog12/olap:/ns3/prog12:/ns3u/prog12:.; export PROPATH
DLC=/usr/dlc; export DLC
PATH=$DLC/bin:$PATH:.; export PATH

# =======var========
file1=recom_ktz.csv #файл работы процедуры
NAME=$(dirname $0)
#NAME=/autons/pricing_ktz
RUNDATE=`date "+%Y%m%d%H%M"`

# =======var========

echo "catalog = $NAME"
cd $NAME

#обработка в случае отсутсвия файла 
n1=$(ls -l |grep .csv -c)
if [ -f $file1 ]
then 
echo "$file1 ready"
else
echo "Not found file $file1"
echo "Found $n1 .csv files"
ls -l| grep .csv
fi
#=====


if [ -f $NAME/*.wrk ]

then
echo "Process is already running"
echo "still run proc: $(date)" >> time.log
exit 9
else
	#if [ -f $NAME/start.now ]
	#then
echo "1_start: $(date)" >> time.log

echo "start: $(date)" > start.wrk
echo "connect progress"

mv ./report_ktz*.csv ./old/
mv ./progress*.log ./old/
wc -l recom_ktz.csv

$DLC/bin/_progres -pf $NAME/auto.pf -T $HOME > progress.log

rm *.wrk
mv *.csv ./old/$RUNDATE.csv
echo "2_stop: $(date)" >> time.log
	#rm start.now
    if [ -f $NAME/progress.log ]
    then
cat progress.log
echo "close progress"
echo "2_stop: $(date)" >> time.log
    else 
echo "no log progress"
exit 1 выход в случае ошибки
fi
	#else
	#echo "no_start: $(date)" >> time.log

	#fi
fi
#=======log parsing======
count_str=$(cat progress.log| wc -l)
echo "$count_str строк в логе"
#cat progress.log | wc -l


#========== обратобка ошибок в логе
#if [ $count_str -gt 0 ]
#    then
#    exit 100
#    else
#    echo "number of error $count_err"
#fi
#=======================

mv ./progress.log ./progress_$RUNDATE.log
