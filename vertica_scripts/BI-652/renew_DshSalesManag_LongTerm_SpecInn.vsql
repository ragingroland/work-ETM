create local temp table tmp_local
on commit preserve rows as
select distinct
	CliInn,
    DataInfo,
    Class294_Code,
    SalesSubChannel,
    Class79_Code,
    Class72_Code,
    max(SumShipped) over(partition by DataInfo, CliInn, Class294_Code) as SumShipped_,
    max(LongTermGoalMnth) over(partition by DataInfo, CliInn, Class294_Code) as LongTermGoalMnth_
from DataMart.DshSalesManag_LongTerm_DivSpecInnMnth;

truncate table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1;
insert into DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1
select
	DataInfo,
	CliInn,
    Class294_Code,
    SalesSubChannel,
    Class79_Code,
    Class72_Code,
    SumShipped_,
    LongTermGoalMnth_
from tmp_local;
commit;

create local temp table tmp_local2
on commit preserve rows as
select distinct
	CliInn,
    DataInfo,
    SalesSubChannel,
    Class79_Code,
    Class72_Code,
    max(SumShipped) over(partition by DataInfo, CliInn) as SumShipped_,
    max(LongTermGoalMnth) over(partition by DataInfo, CliInn) as LongTermGoalMnth_
from DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth;

truncate table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1;
insert into DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1
select
	DataInfo,
	CliInn,
    SalesSubChannel,
    Class79_Code,
    Class72_Code,
    SumShipped_,
    LongTermGoalMnth_
from tmp_local2;
commit;

create local temp table tmp_local3
on commit preserve rows as
select distinct
	CliInn,
    DataInfo,
    SalesSubChannel,
    Class63_Code_3,
    Class79_Code,
    Class72_Code,
    max(SumShipped) over(partition by DataInfo, CliInn, Class63_Code_3) as SumShipped_,
    max(LongTermGoalMnth) over(partition by DataInfo, CliInn, Class63_Code_3) as LongTermGoalMnth_
from DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth;

truncate table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2;
insert into DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2
select
	DataInfo,
	CliInn,
    SalesSubChannel,
    left(Class63_Code_3, 4) as Class63_Code_2,
    Class63_Code_3,
    Class79_Code,
    Class72_Code,
    SumShipped_,
    LongTermGoalMnth_
from tmp_local3;
commit;

create local temp table tmp_local4
on commit preserve rows as
select distinct
	CliInn,
    DataInfo,
    SalesSubChannel,
    Class63_Code_2,
    Class79_Code,
    Class72_Code,
    max(SumShipped) over(partition by DataInfo, CliInn, Class63_Code_2) as SumShipped_,
    max(LongTermGoalMnth) over(partition by DataInfo, CliInn, Class63_Code_2) as LongTermGoalMnth_
from DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth;

truncate table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3;
insert into DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3
select
	DataInfo,
	CliInn,
    SalesSubChannel,
    Class63_Code_2,
    Class79_Code,
    Class72_Code,
    SumShipped_,
    LongTermGoalMnth_
from tmp_local4;
commit;

create local temp table tmp_local5
on commit preserve rows as
select distinct
	DataInfo,
    CliInn,
    Class63_Code_2,
    Class63_Code_3,
    Class294_Code,
    SalesSubChannel,
    Class79_Code,
    Class72_Code,
    max(SumShipped) over(partition by DATAINFO,CLIINN, Class63_Code_3, CLASS294_CODE) as SumShipped_,
    max(LongTermGoalMnth) over(PARTITION BY DATAINFO,CLIINN, Class63_Code_3, CLASS294_CODE) as LongTermGoalMnth_
from DataMart.DshSalesManag_LongTerm_DivSpecInnMnth;

truncate table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2;
insert into DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2
select * from tmp_local5;

commit;