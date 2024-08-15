create table DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll (
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class55_Code varchar(20),
    Category varchar(22),
    StaffAmountPlan float)
order by
    Class63_Code_2,
    Class55_Code,
    Category,
    Class63_Code_3,
    DataInfo
segmented by hash (
DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.Class63_Code_2,
DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.Class55_Code,
DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.Category,
DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.Class63_Code_3
) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll is 'Витрина-близнец DataMart.DshSalesManag_EfDSMSheet_SalStafTarg содержащая исключительно плановую численность';
comment on column DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.DataInfo is 'Дата среза';
comment on column DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.Class55_Code is 'Специализация (код 55-го класса)';
comment on column DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.Category is 'Категория';
comment on column DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll.StaffAmountPlan is 'Численность план';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
-- !!! для ED добавляем по роли etl_ed_role:
--                 public и dataprime - только смотрим
--                 datamart          - все 
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
