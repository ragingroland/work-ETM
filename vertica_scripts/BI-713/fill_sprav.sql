create local temp table tmp_local (
    Clust_Code int,
    Clust_Name varchar(80))
on commit preserve rows;

create local temp table tmp_local2 (
    Clust_Code int,
    SubClust_Code int,
    LowBound float,
    UpBound float,
    Clust_Name varchar(80),
    SubClust_Name varchar(240))
on commit preserve rows;

insert into tmp_local values (1, 'Лучшая цена (Цена ЭТМ от -0.5% и ниже)');
insert into tmp_local values (2, 'Лучшая цена (Цена ЭТМ от -5% и ниже)');
insert into tmp_local values (3, 'Цена ЭТМ (от 0.1% и выше)');
insert into tmp_local values (4, 'Цена ЭТМ (от 0.1% и ниже)');

insert into tmp_local2 values (1, 101, -999999.0, -0.5, 'Лучшая цена (Цена ЭТМ от -0.5% и ниже)', 'Лучшая цена (Цена ЭТМ от -0.5% и ниже)');
insert into tmp_local2 values (1, 102, -0.5, 1.0, 'Лучшая цена (Цена ЭТМ от -0.5% и ниже)', 'Средняя цена (Цена ЭТМ от -0.5% до +1%)');
insert into tmp_local2 values (1, 103, 1.0, 999999.0, 'Лучшая цена (Цена ЭТМ от -0.5% и ниже)', 'Высокая цена (Цена ЭТМ +1% и выше)');

insert into tmp_local2 values (2, 201, -999999.0, -5.0, 'Лучшая цена (Цена ЭТМ от -5% и ниже)', 'Лучшая цена (Цена ЭТМ от -5% и ниже)');
insert into tmp_local2 values (2, 202, -5.0, 5.0, 'Лучшая цена (Цена ЭТМ от -5% и ниже)', 'Средняя цена (Цена ЭТМ от -5% до +5%)');
insert into tmp_local2 values (2, 203, 5.0, 999999.0, 'Лучшая цена (Цена ЭТМ от -5% и ниже)', 'Высокая цена (Цена ЭТМ +5% и выше)');

insert into tmp_local2 values (3, 306, 25.0, 999999.0, 'Цена ЭТМ (от 0.1% и выше)', 'от 25% и выше');
insert into tmp_local2 values (3, 305, 20.0, 25.0,'Цена ЭТМ (от 0.1% и выше)', 'от 20% до 25%');
insert into tmp_local2 values (3, 304, 15.0, 20.0, 'Цена ЭТМ (от 0.1% и выше)', 'от 15% до 20%');
insert into tmp_local2 values (3, 303, 10.0, 15.0, 'Цена ЭТМ (от 0.1% и выше)', 'от 10% до 15%');
insert into tmp_local2 values (3, 302, 5.0, 10.0, 'Цена ЭТМ (от 0.1% и выше)', 'от 5% до 10%');
insert into tmp_local2 values (3, 301, 0.1, 5.0, 'Цена ЭТМ (от 0.1% и выше)', 'от +0.1% до 5%');

insert into tmp_local2 values (4, 407, -0.1, 0.1, 'Цена ЭТМ (от 0.1% и ниже)', 'от -0.1% до 0.1%');
insert into tmp_local2 values (4, 406, -5.0, -0.1, 'Цена ЭТМ (от 0.1% и ниже)', 'от -5% до -0.1%');
insert into tmp_local2 values (4, 405, -10.0, -5.0, 'Цена ЭТМ (от 0.1% и ниже)', 'от -10% до -5%');
insert into tmp_local2 values (4, 404, -15.0, -10.0, 'Цена ЭТМ (от 0.1% и ниже)', 'от -15% до -10%');
insert into tmp_local2 values (4, 403, -20.0, -15.0, 'Цена ЭТМ (от 0.1% и ниже)', 'от -20% до -15%');
insert into tmp_local2 values (4, 402, -25.0, -20.0, 'Цена ЭТМ (от 0.1% и ниже)', 'от -25% до -20%');
insert into tmp_local2 values (4, 401, -999999.0, -25.0, 'Цена ЭТМ (от 0.1% и ниже)', 'от -25% и ниже');

insert into DataMart.DescClustCmpPrcEtmMarkt
select * from tmp_local;
commit;

update tmp_local2
set
    LowBound = LowBound / 100,
    UpBound = UpBound / 100
where LowBound != -999999 and Upbound != 999999;

update tmp_local2
set
    UpBound = UpBound / 100
where LowBound = -999999;

update tmp_local2
set
    LowBound = LowBound / 100
where Upbound = 999999;

insert into DataMart.DescSubClustCmpPrcEtmMarkt
select * from tmp_local2;
commit;