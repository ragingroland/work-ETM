CREATE LOCAL TEMP TABLE tmp_slices -- срез даты
     (DataInfo date)
ON COMMIT PRESERVE ROWS;
TRUNCATE TABLE  tmp_slices;

INSERT INTO tmp_slices
 WITH
   Vw_ListDays AS
   (
    SELECT  ts::date AS DataInfo
    FROM (
           SELECT Max(DataInfo)::TIMESTAMP AS tm
           FROM  Ot
           UNION
           SELECT ADD_MONTHS(TRUNC(Max(DataInfo), 'year'), - 36)::TIMESTAMP AS tm
           FROM  Ot
          ) AS t
    TIMESERIES ts as '1 day' OVER (ORDER BY tm)
   )
   SELECT
      DISTINCT TRUNC(DataInfo, 'month')::DATE AS DataInfo
    FROM Vw_ListDays;
COMMIT;

create local temp table tmp_local (
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class305_Code_1 varchar(6),
    OtPlan float,
    OtFact float)
on commit preserve rows;

insert into tmp_local -- факт ТО
SELECT
    Ot.DataInfo,
    COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 4), '') AS Class63_Code_2,
    COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 6), '') AS Class63_Code_3,
    COALESCE(RgdDivisDprt.Class305_Code_1, '') AS Class305_Code_1,
    0 as OtPlan,
    SUM(Ot.SumSaled) AS OtFact
FROM tmp_slices INNER JOIN
     Ot ON
  Ot.DataInfo = tmp_slices.DataInfo
  LEFT JOIN DescRgd ON DescRgd.RgdCode = Ot.RgdCode
  LEFT JOIN RgdDivisDprt ON RgdDivisDprt.RgdCode = Ot.RgdCode
  LEFT JOIN ClassGroup ON
          ClassGroup.ClassTypeSrc = 37 AND
          ClassGroup.ClassTypeGrp = 63 AND
          ClassGroup.ClassCodeSrc = SUBSTRING(Ot.Class37_Code, 1, 5) AND
          ClassGroup.ClassCodeGrp LIKE 'УП%'
  WHERE     NOT( SUBSTRING(COALESCE(DescRgd.Class3_Code, ''), 1, 1) = '2')
  GROUP BY
        Ot.DataInfo,
        COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 4), ''),
    COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 6), ''),
    COALESCE(RgdDivisDprt.Class305_Code_1, '');

create local temp table tmp_local2 -- план ТО
on commit preserve rows as
SELECT
       DataPrime.OtBudgPlan_Fin.DataInfo,
       COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 4), '')  AS Class63_Code_2,
       COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 6), '')  AS Class63_Code_3,
       left(Class305_Code, 3) as Class305_Code_1,
       SUM(DataPrime.OtBudgPlan_Fin.OtBudgPlan + DataPrime.OtBudgPlan_Fin.OtNdsBudgPlan)    AS OtPlan,
       0 as OtFact
    FROM tmp_slices INNER JOIN
       DataPrime.OtBudgPlan_Fin ON
     DataPrime.OtBudgPlan_Fin.DataInfo = tmp_slices.DataInfo
     LEFT JOIN ClassGroup ON
          ClassGroup.ClassTypeSrc = 37 AND
          ClassGroup.ClassTypeGrp = 63 AND
          ClassGroup.ClassCodeSrc = SUBSTRING(DataPrime.OtBudgPlan_Fin.Class37_Code, 1, 5) AND
          ClassGroup.ClassCodeGrp LIKE 'УП%'
  GROUP BY
  DataPrime.OtBudgPlan_Fin.DataInfo,
  COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 4), ''),
  COALESCE(SUBSTRING(ClassGroup.ClassCodeGrp, 1, 6), ''),
  left(Class305_Code, 3);

truncate table DataMart.DshGenerManag_OtPlan;
insert into DataMart.DshGenerManag_OtPlan
select
    l1.DataInfo,
    l1.Class63_Code_2,
    l1.Class63_Code_3,
    l1.Class305_Code_1,
    l2.OtPlan,
    l1.OtFact
from tmp_local l1
inner join tmp_local2 l2 on l1.DataInfo = l2.DataInfo
    and l1.Class63_Code_2 = l2.Class63_Code_2
    and l1.Class63_Code_3 = l2.Class63_Code_3
    and l1.Class305_Code_1 = l2.Class305_Code_1;
commit;
