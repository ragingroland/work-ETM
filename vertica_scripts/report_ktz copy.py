import datetime
import pandas as pd
import vertica_python
import os
import argparse

datetime_now = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
print(f'Started report generation at {datetime.datetime.now().strftime("%Y.%m.%d %H:%M:%S")}')

base_path = '/autons/pricing_ktz'
# base_path = '/home/manage/KTZ'
old_path = 'old'
upload_file_name = 'recom_ktz.csv'
report_file_name = f'report_ktz_{datetime_now}.csv'

# parser = argparse.ArgumentParser(description='Get days delta')
# parser.add_argument('days_delta', type=int, help='days delta')
# args = parser.parse_args()
# delta = args.days_delta

def clear_folder():
    for file in os.listdir(base_path):
        if file == upload_file_name:
            os.remove(os.path.join(base_path, file))
        elif '.csv' in file:
            os.rename(os.path.join(base_path, file), os.path.join(base_path, old_path, file))

def save_report(data, columns, file_name):
    file_path = os.path.join(base_path, file_name)
    upload_file_path = os.path.join(base_path, upload_file_name)
    clmns = []
    for clmn in columns:
        clmns.append(clmn[0])
    df = pd.DataFrame(data, columns=clmns, dtype='str')
    df.to_csv(file_path, sep=';', index=False, encoding='1251')
    df.to_csv(upload_file_path, sep=';', index=False, encoding='1251')
    print(f'Saved {df.shape[0]} lines to file {file_name} at {datetime.datetime.now().strftime("%Y.%m.%d %H:%M:%S")}')

conn_info = {
    'host': '172.24.2.140',
    'port': 5433,
    'user': 'user_etl',
    'password': 'useretlvert92',
    'database': 'DWH',
    'autocommit': False,
    'connection_load_balance': True
    # 'unicode_error': 'strict',
    # 'log_level': logging.DEBUG
}

# clear_folder()

# with open(os.path.join(base_path, 'report_InfoClustRgd6ForActions_new.vsql'), 'r') as f:
#     query = f.read()

# query = query.replace(':delta', str(delta))
query = """
        --табл с датами
        CREATE LOCAL TEMP TABLE tmp_date
        (date1m date
        ,date2m date
        ,date3m date
        ,date4m date)
        ON COMMIT PRESERVE ROWS;

        TRUNCATE TABLE tmp_date;

        INSERT INTO tmp_date
        select
         trunc(ADD_MONTHS(CURRENT_DATE,-1),'MM')
        ,trunc(ADD_MONTHS(CURRENT_DATE,-2),'MM')
        ,trunc(ADD_MONTHS(CURRENT_DATE,-3),'MM')
        ,trunc(ADD_MONTHS(CURRENT_DATE,-4),'MM');

        --общ таблица товаров по кластерам 5 и 6 за 4 последних месяца
        CREATE LOCAL TEMP TABLE tmp_main
        (DataInfo date
        ,StoreCode varchar(20)
        ,NetNum int
        ,CodeCluster int
        ,RgdCode int
        ,MnfCode int
        ,Class333 varchar(20)
        ,Class43 varchar(10))
        ON COMMIT PRESERVE ROWS;

        TRUNCATE TABLE tmp_main;

        INSERT INTO tmp_main
        select distinct
         t1.DataInfo
        ,t1.StoreCode
        ,t2.NetNum
        ,t1.CodeCluster
        ,t1.RgdCode
        ,DescRgd.MnfCode
        ,DescRgd.Class33_Code
        ,case when SUBSTRING(t2.Class82_Code,5,2)=11 then DescRgd.Class43_Code_Rg11
        	  when SUBSTRING(t2.Class82_Code,5,2)=12 then DescRgd.Class43_Code_Rg12
        	  when SUBSTRING(t2.Class82_Code,5,2)=13 then DescRgd.Class43_Code_Rg13
        	  when SUBSTRING(t2.Class82_Code,5,2)=14 then DescRgd.Class43_Code_Rg14
        	  when SUBSTRING(t2.Class82_Code,5,2)=15 then DescRgd.Class43_Code_Rg15
        	  when SUBSTRING(t2.Class82_Code,5,2)=16 then DescRgd.Class43_Code_Rg16
        	  when SUBSTRING(t2.Class82_Code,5,2)=17 then DescRgd.Class43_Code_Rg17
        	  when SUBSTRING(t2.Class82_Code,5,2)=19 then DescRgd.Class43_Code_Rg19
        	  when SUBSTRING(t2.Class82_Code,5,2)=35 then DescRgd.Class43_Code_Rg35
        	  else '' end as Class43 --43 класс выбирается по ЛЦ
        from tmp_date,DataPrime.InfoRgdClustersInvRat t1
        left join public.DescRgd on DescRgd.RgdCode = t1.RgdCode
        left join DataPrime.price_CPlinkNetNum t2 on SUBSTRING(t2.Class82_Code,5,2) = t1.StoreCode
        where t1.DataInfo >= date4m --4 мес
        and t1.CodeCluster in ('5','6')
        and Class43 not like '%AF' --исключаем
        UNION ALL
        select distinct
         t1.DataInfo
        ,t1.StoreCode
        ,t2.NetNum
        ,t1.CodeCluster
        ,t1.RgdCode
        ,DescRgd.MnfCode
        ,DescRgd.Class3_Code
        ,case when SUBSTRING(t2.Class82_Code,5,2)=11 then DescRgd.Class43_Code_Rg11
        	  when SUBSTRING(t2.Class82_Code,5,2)=12 then DescRgd.Class43_Code_Rg12
        	  when SUBSTRING(t2.Class82_Code,5,2)=13 then DescRgd.Class43_Code_Rg13
        	  when SUBSTRING(t2.Class82_Code,5,2)=14 then DescRgd.Class43_Code_Rg14
        	  when SUBSTRING(t2.Class82_Code,5,2)=15 then DescRgd.Class43_Code_Rg15
        	  when SUBSTRING(t2.Class82_Code,5,2)=16 then DescRgd.Class43_Code_Rg16
        	  when SUBSTRING(t2.Class82_Code,5,2)=17 then DescRgd.Class43_Code_Rg17
        	  when SUBSTRING(t2.Class82_Code,5,2)=19 then DescRgd.Class43_Code_Rg19
        	  when SUBSTRING(t2.Class82_Code,5,2)=35 then DescRgd.Class43_Code_Rg35
        	  else '' end as Class43 --43 класс выбирается по ЛЦ
        from tmp_date,DataPrime.InfoRgdClustersInvRat t1
        left join public.DescRgd on DescRgd.RgdCode = t1.RgdCode
        left join DataPrime.price_CPlinkNetNum t2 on SUBSTRING(t2.Class82_Code,5,2) = t1.StoreCode
        where t1.DataInfo >= date4m --4 мес
        and t1.CodeCluster in ('5','6')
        and Class43 not like '%AF' --исключаем
        ;

        --табл товаров с параметрами, подобранными по 33 классу и производителю
        CREATE LOCAL TEMP TABLE tmp_33mnf
        (Class_Type int
        ,Class_Code varchar(20)
        ,MnfCode int
        ,RgdCode int
        ,K_1 float
        ,K_2 float
        ,K_3 float
        ,K_4 float
        ,Price_Type int
        ,CodeCluster int
        ,DataInfo date
        ,StoreCode varchar(20)
        ,NetNum int
        ,Class333 varchar(20))
        ON COMMIT PRESERVE ROWS;

        TRUNCATE TABLE tmp_33mnf;

        INSERT INTO tmp_33mnf
        WITH tt as (
        select
         prs.Class_Type
        ,prs.Class_Code
        ,prs.MnfCode
        ,tmp_main.RgdCode
        ,K_1
        ,K_2
        ,K_3
        ,K_4
        ,prs.Price_Type
        ,prs.Clust_Code
        ,tmp_main.DataInfo
        ,tmp_main.StoreCode
        ,tmp_main.NetNum
        ,tmp_main.Class333
        ,ROW_NUMBER() OVER(PARTITION BY prs.MnfCode,tmp_main.RgdCode,prs.Clust_Code,tmp_main.StoreCode,tmp_main.NetNum ORDER BY LENGTH(prs.Class_Code) desc) AS rw --возьмем с единицами
        from tmp_date,DataPrime.Params4StockByRgdClust prs
        left join tmp_main on tmp_main.MnfCode=prs.MnfCode and tmp_main.CodeCluster=prs.Clust_Code and tmp_main.Class333 like upper(prs.Class_Code)||'%'
        where tmp_main.DataInfo is not null and DataInfo >= date1m --1 мес
        and prs.Class_Type=33 and prs.MnfCode is not null
        )
        select Class_Type,Class_Code,MnfCode,RgdCode,K_1,K_2,K_3,K_4,Price_Type,Clust_Code,DataInfo,StoreCode,NetNum,Class333 from tt where rw = 1
        ;

        --табл товаров с параметрами, подобранными по 3 классу и производителю
        CREATE LOCAL TEMP TABLE tmp_3mnf
        (Class_Type int
        ,Class_Code varchar(20)
        ,MnfCode int
        ,RgdCode int
        ,K_1 float
        ,K_2 float
        ,K_3 float
        ,K_4 float
        ,Price_Type int
        ,CodeCluster int
        ,DataInfo date
        ,StoreCode varchar(20)
        ,NetNum int
        ,Class333 varchar(20))
        ON COMMIT PRESERVE ROWS;

        TRUNCATE TABLE tmp_3mnf;

        INSERT INTO tmp_3mnf
        WITH tt as (
        select
         prs.Class_Type
        ,prs.Class_Code
        ,prs.MnfCode
        ,tmp_main.RgdCode
        ,K_1
        ,K_2
        ,K_3
        ,K_4
        ,prs.Price_Type
        ,prs.Clust_Code
        ,tmp_main.DataInfo
        ,tmp_main.StoreCode
        ,tmp_main.NetNum
        ,tmp_main.Class333
        ,ROW_NUMBER() OVER(PARTITION BY prs.MnfCode,tmp_main.RgdCode,prs.Clust_Code,tmp_main.StoreCode,tmp_main.NetNum ORDER BY LENGTH(prs.Class_Code) desc) AS rw --возьмем с единицами
        from tmp_date,DataPrime.Params4StockByRgdClust prs
        left join tmp_main on tmp_main.MnfCode=prs.MnfCode and tmp_main.CodeCluster=prs.Clust_Code and tmp_main.Class333 like upper(prs.Class_Code)||'%'
        where tmp_main.DataInfo is not null and DataInfo >= date1m --1 мес
        and prs.Class_Type=3 and prs.MnfCode is not null
        and not EXISTS (select 1 from tmp_33mnf where tmp_33mnf.RgdCode = tmp_main.RgdCode)
        )
        select Class_Type,Class_Code,MnfCode,RgdCode,K_1,K_2,K_3,K_4,Price_Type,Clust_Code,DataInfo,StoreCode,NetNum,Class333 from tt where rw = 1
        ;

        --табл товаров с параметрами, подобранными по 33 классу и без производителя
        CREATE LOCAL TEMP TABLE tmp_33
        (Class_Type int
        ,Class_Code varchar(20)
        ,MnfCode int
        ,RgdCode int
        ,K_1 float
        ,K_2 float
        ,K_3 float
        ,K_4 float
        ,Price_Type int
        ,CodeCluster int
        ,DataInfo date
        ,StoreCode varchar(20)
        ,NetNum int
        ,Class333 varchar(20))
        ON COMMIT PRESERVE ROWS;

        TRUNCATE TABLE tmp_33;

        INSERT INTO tmp_33
        WITH tt as (
        select
         prs.Class_Type
        ,prs.Class_Code
        ,prs.MnfCode
        ,tmp_main.RgdCode
        ,K_1
        ,K_2
        ,K_3
        ,K_4
        ,prs.Price_Type
        ,prs.Clust_Code
        ,tmp_main.DataInfo
        ,tmp_main.StoreCode
        ,tmp_main.NetNum
        ,tmp_main.Class333
        ,ROW_NUMBER() OVER(PARTITION BY tmp_main.RgdCode,prs.Clust_Code,tmp_main.StoreCode,tmp_main.NetNum ORDER BY LENGTH(prs.Class_Code) desc) AS rw --возьмем с единицами
        from tmp_date,DataPrime.Params4StockByRgdClust prs
        left join tmp_main on tmp_main.CodeCluster=prs.Clust_Code and tmp_main.Class333 like upper(prs.Class_Code)||'%'
        where tmp_main.DataInfo is not null and DataInfo >= date1m --1 мес
        and prs.Class_Type=33 and prs.MnfCode is null
        and not EXISTS (select 1 from tmp_33mnf where tmp_33mnf.RgdCode = tmp_main.RgdCode)
        and not EXISTS (select 1 from tmp_3mnf  where  tmp_3mnf.RgdCode = tmp_main.RgdCode)
        )
        select Class_Type,Class_Code,MnfCode,RgdCode,K_1,K_2,K_3,K_4,Price_Type,Clust_Code,DataInfo,StoreCode,NetNum,Class333 from tt where rw = 1
        ;

        --табл товаров с параметрами, подобранными по 3 классу и без производителя
        CREATE LOCAL TEMP TABLE tmp_3
        (Class_Type int
        ,Class_Code varchar(20)
        ,MnfCode int
        ,RgdCode int
        ,K_1 float
        ,K_2 float
        ,K_3 float
        ,K_4 float
        ,Price_Type int
        ,CodeCluster int
        ,DataInfo date
        ,StoreCode varchar(20)
        ,NetNum int
        ,Class333 varchar(20))
        ON COMMIT PRESERVE ROWS;

        TRUNCATE TABLE tmp_3;

        INSERT INTO tmp_3
        WITH tt as (
        select
         prs.Class_Type
        ,prs.Class_Code
        ,prs.MnfCode
        ,tmp_main.RgdCode
        ,K_1
        ,K_2
        ,K_3
        ,K_4
        ,prs.Price_Type
        ,prs.Clust_Code
        ,tmp_main.DataInfo
        ,tmp_main.StoreCode
        ,tmp_main.NetNum
        ,tmp_main.Class333
        ,ROW_NUMBER() OVER(PARTITION BY tmp_main.RgdCode,prs.Clust_Code,tmp_main.StoreCode,tmp_main.NetNum ORDER BY LENGTH(prs.Class_Code) desc) AS rw --возьмем с единицами
        from tmp_date,DataPrime.Params4StockByRgdClust prs
        left join tmp_main on tmp_main.CodeCluster=prs.Clust_Code and tmp_main.Class333 like upper(prs.Class_Code)||'%'
        where tmp_main.DataInfo is not null and DataInfo >= date1m --1 мес
        and prs.Class_Type=3 and prs.MnfCode is null
        and not EXISTS (select 1 from tmp_33mnf where tmp_33mnf.RgdCode = tmp_main.RgdCode)
        and not EXISTS (select 1 from tmp_3mnf  where  tmp_3mnf.RgdCode = tmp_main.RgdCode)
        and not EXISTS (select 1 from tmp_33    where    tmp_33.RgdCode = tmp_main.RgdCode)
        )
        select Class_Type,Class_Code,MnfCode,RgdCode,K_1,K_2,K_3,K_4,Price_Type,Clust_Code,DataInfo,StoreCode,NetNum,Class333 from tt where rw = 1
        ;

        --табл товаров общая
        CREATE LOCAL TEMP TABLE tmp_all
        (Class_Type int
        ,Class_Code varchar(20)
        ,MnfCode int
        ,RgdCode int
        ,K_1 float
        ,K_2 float
        ,K_3 float
        ,K_4 float
        ,Price_Type int
        ,CodeCluster int
        ,DataInfo date
        ,StoreCode varchar(20)
        ,NetNum int
        ,Class333 varchar(20))
        ON COMMIT PRESERVE ROWS;

        TRUNCATE TABLE tmp_all;

        INSERT INTO tmp_all
        select * from tmp_33mnf
        union all
        select * from tmp_3mnf
        union all
        select * from tmp_33
        union all
        select * from tmp_3;

        --табл итоговая
        CREATE LOCAL TEMP TABLE tmp_itog
        (Action_Type varchar(12)
        ,Action_StartDate varchar(20)
        ,Action_EndDate varchar(20)
        ,RgdCode int
        ,Coeff float
        ,Class71 varchar(10)
        ,Class72 varchar(4)
        ,NetNum int
        ,Price_Type int)
        ON COMMIT PRESERVE ROWS;

        TRUNCATE TABLE tmp_itog;

        INSERT INTO tmp_itog
        select
        '0__KTZ'
        ,TO_CHAR(CURRENT_DATE, 'dd.mm.yyyy')
        ,TO_CHAR(trunc(last_day(CURRENT_DATE)), 'dd.mm.yyyy')
        ,RgdCode
        ,case   when    EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date1m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        not EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date2m and DataInfo < date1m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                then K_1
                when    EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date1m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date2m and DataInfo < date1m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        not EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date3m and DataInfo < date2m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                then K_2
                when    EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date1m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date2m and DataInfo < date1m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date3m and DataInfo < date2m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        not EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date4m and DataInfo < date3m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                then K_3
                when    EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date1m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date2m and DataInfo < date1m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date3m and DataInfo < date2m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                    and
                        EXISTS (select 1 from tmp_date,tmp_main where DataInfo >= date4m and DataInfo < date3m and tmp_main.RgdCode=RgdCode and tmp_main.NetNum=NetNum)
                then K_4
                end
        ,''
        ,''
        ,NetNum
        ,Price_Type
        from tmp_all;

        select * from tmp_itog;"""


try:
    connection = vertica_python.connect(**conn_info)
    cursor = connection.cursor()
    cursor.execute(query)
    # rows = [row[0] for row in cursor.fetchall()]
    rows = cursor.fetchall()
    print(rows)
    columns = cursor.description
    # save_report(rows, columns, report_file_name)

finally:
    connection.close()

print(f'Finished reports generation at {datetime.datetime.now().strftime("%Y.%m.%d %H:%M:%S")}')