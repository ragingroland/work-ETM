CREATE LOCAL TEMP TABLE tmp
ON COMMIT PRESERVE ROWS AS
select * from DataPrime.RgdMnfBrand where RgdCode = 0;
truncate table tmp;

COPY tmp
FROM LOCAL 'H:\OLAP\RgdMnfBrand\DATA\RgdMnfBrand.vcsv'
    abort on error
    DELIMITER '|'
    NULL ''
    ENCLOSED BY '"'
    REJECTED DATA 'H:\OLAP\RgdMnfBrand\RUN\RgdMnfBrand.rej'
    EXCEPTIONS 'H:\OLAP\RgdMnfBrand\RUN\RgdMnfBrand.exc' DIRECT;

--почистить в исходных табличках срезы
TRUNCATE TABLE DataPrime.RgdMnfBrand;
COMMIT;

--Очищает все проекции указанной таблицы
SELECT PURGE_TABLE('DataPrime.RgdMnfBrand');

--загрузить в таблички
truncate table DataPrime.RgdMnfBrand;
INSERT INTO DataPrime.RgdMnfBrand
SELECT * FROM tmp;
COMMIT;