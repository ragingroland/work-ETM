--------------
-- 07.08.2024 !!! в пятницу надо уже готовый дашборд, поэтому срочно
--------------
CREATE LOCAL TEMP TABLE tmp_PlanStaff
ON COMMIT PRESERVE ROWS AS
SELECT
    DATE_TRUNC('month', DataPrime.OneC_StaffSchedPlan.date_staff) :: DATE AS DataInfo,
    SUBSTRING(DataPrime.OneC_RfBk_unit.Class37_Code, 1, 5) AS Class37_Code,
    COALESCE(NULLIF(DataPrime.OneC_StaffSchedPlan.emp_specialization, ''), 'Нет спец-и') AS Class55_Code,
    COALESCE(DataPrime.RulesCnvEmpStat1C2ProgCat.Category, DataPrime.OneC_StaffSchedPlan.emp_status) AS Category,
    SUM(DataPrime.OneC_StaffSchedPlan.amount) AS StaffAmountPlan
FROM
    DataPrime.OneC_StaffSchedPlan
INNER JOIN
    DataPrime.OneC_RfBk_unit ON DataPrime.OneC_StaffSchedPlan.unit_id = DataPrime.OneC_RfBk_unit.unit_id
LEFT JOIN DataPrime.RulesCnvEmpStat1C2ProgCat ON DataPrime.RulesCnvEmpStat1C2ProgCat.emp_status = DataPrime.OneC_StaffSchedPlan.emp_status
WHERE
    DataPrime.OneC_StaffSchedPlan.saled = 'Saled' AND
    DataPrime.OneC_RfBk_unit.Class37_Code <> ''  AND
    DataPrime.OneC_StaffSchedPlan.date_staff >= TRUNC(ADD_MONTHS(CURRENT_DATE-1, -24), 'YEAR') AND
    DataPrime.OneC_StaffSchedPlan.date_staff <= CURRENT_DATE
    AND DataPrime.OneC_StaffSchedPlan.emp_status <> 'Уволен'
GROUP BY
    1, 2, 3, 4;

truncate table DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll;
insert into DataMart.DshSalesManag_EfDSMSheet_PlanStaffAll
select -- правила формирования аналогичны формированию витрины DataMart.DshSalesManag_EfDSMSheet_SalStafTarg
	tmp_PlanStaff.DataInfo,
	COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 4), '') AS Class63_Code_2,
	COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 6), '') AS Class63_Code_3,
    tmp_PlanStaff.Class55_Code,
    tmp_PlanStaff.Category,
    SUM(tmp_PlanStaff.StaffAmountPlan) as StaffAmountPlan
from tmp_PlanStaff
LEFT JOIN ClassGroup ON 
    ClassGroup.ClassTypeSrc = 37 AND
    ClassGroup.ClassTypeGrp = 63 AND
    ClassGroup.ClassCodeSrc = tmp_PlanStaff.Class37_Code AND
    ClassGroup.ClassCodeGrp LIKE 'УП%' 
Group by 1, 2, 3, 4, 5;
commit;