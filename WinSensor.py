import pendulum
import os
import time

from airflow import DAG
from airflow.providers.microsoft.winrm.hooks.winrm import WinRMHook
from airflow.providers.microsoft.winrm.operators.winrm import WinRMOperator
from airflow.operators.empty import EmptyOperator
from airflow.providers.microsoft.psrp.operators.psrp import PsrpOperator
from airflow.providers.sftp.sensors.sftp import SFTPSensor
from airflow.timetables.trigger import CronTriggerTimetable
from airflow.utils.edgemodifier import Label

doc_md_DAG= """\
Тестовый даг для тестирования Windows POWERSHELL
"""

default_args = {
	'owner': 'Anton',
	'depends_on_past': False,
	'email': ['asu.rnd@etm.ru'],
	'email_on_failure': False,
	'email_on_retry': False,
	}


with DAG(
    dag_id="PSRC_Sensor",
    description="Training pipeline",
    default_args=default_args,
    start_date=pendulum.datetime(2022, 10, 26, tz="Europe/Berlin"),
    schedule_interval=CronTriggerTimetable('0  18 * * 4,1', timezone="UTC"),
    tags=["Windows","Kozmenko","Ivanov_V"],
    catchup=False,
    orientation="TB",
    doc_md=doc_md_DAG,
) as dag:
    

    init = EmptyOperator(
        task_id="init",
    )

    init1 = EmptyOperator(  #заменить на сенсор
        task_id="ps_sensor",
    )

    
    new_pwsh = PsrpOperator(
        task_id="Testing_powershell_operator",
        psrp_conn_id="PS_55srv",
        #powershell="start 'C:\Temp\\1.bat' ",
        powershell="New-Item -Force -Path 'C:\Temp\\file.txt' -ItemType File ",
        #powershell="Get-ChildItem -Path C:\ ",
        wsman_options={"ssl": False, "auth": "credssp"},
    )

    new_pwsh1 = PsrpOperator(
        task_id="Testing_powershell_operator1",
        psrp_conn_id="PS_55srv",
        powershell="start 'C:\Temp\\1.bat' ",
        #powershell="New-Item -Path 'C:\Temp\\file.txt' -ItemType File ",
        #powershell="Get-ChildItem -Path C:\ ",
        wsman_options={"ssl": False, "auth": "credssp"},
    )
   
    end = EmptyOperator(
        task_id="end",
    )

   
init >> Label("Создаем файл на ВинСервере") >> new_pwsh >> Label("Проверка что создался файл") >> init1 >> Label("Запускаем батник, что удаляет файл") >> new_pwsh1 >> end