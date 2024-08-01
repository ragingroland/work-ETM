CREATE TABLE DataMart.DshLogistManag_GrdLvl_AssessQltCompl
(
    Grade int NOT NULL,
    LowBound float,
    UpBound float
);

COMMENT ON TABLE DataPrime.DshLogistManag_GrdLvl_AssessQltCompl IS 'Справочник уровней принятия решения по рекламациям';
COMMENT ON COLUMN DataPrime.DshLogistManag_GrdLvl_AssessQltCompl.Grade IS 'Оценка уровня принятия решения';
COMMENT ON COLUMN DataPrime.DshLogistManag_GrdLvl_AssessQltCompl.LowBound IS 'Нижняя граница, в процентах';
COMMENT ON COLUMN DataPrime.DshLogistManag_GrdLvl_AssessQltCompl.UpBound IS 'Верхняя граница, в процентах'

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