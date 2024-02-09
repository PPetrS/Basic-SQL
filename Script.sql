-- Search the database for cases where there is an EPZP or EPZP-man classification 
-- and sort them primarily by debt size and secondarily by date.

SELECT  
	eazv.c_zk, 
	date(eazv.t_stam_prn) as 'založeno', 
	eazv.vl as 'klasifikace', 
	xeaQOprS(c_zk) as 'oprávněný', 
	xeanoj(c_zk) as 'jistina' 
FROM eazv 
WHERE eazv.vl IN ('EPZP','EPZP-man') 
AND eazv.ind_pl=1 ORDER BY xeanoj(c_zk) DESC, date(eazv.t_stam_prn);


-- Search all completed property auction cases in the last 10 days.
SELECT  
	c_zk 
FROM eau 
WHERE c_up IN (1062, 1607)
AND EXISTS (SELECT * FROM eau eauEND WHERE eau.c_zk=eauEND.c_zk and eauEND.c_up=598 and eauEND.DT_UR>(today()-10));


-- Search CUP documents by date range between 17.05.2023 and 22.06.2023
SELECT 
	c_zk, 
	dt_u, 
	dt_ur, 
	c_spis, 
	POPIS_U 
FROM eau 
WHERE c_up = 1013 AND dt_u BETWEEN 20171001 AND 20171031;


-- Search for active cases for the sale of immovable property subject to pledge
SELECT DISTINCT 
	eaz.c_zk, 
	G_EX, 
	TYP 
FROM eaz JOIN eau ON eaz.c_zk = eau.c_zk 
WHERE eaz.IND_AKTIV = 'A' AND eaz.typ = 'Z';


-- Build a SQL query on selected individual cases, looking for the number of issued "EPN" by date and the number of "LV"
SELECT DISTINCT 
	c_zk, 
	(select count() from eau eauEPN where eau.c_zk=eauEPN.c_zk and eauEPN.c_up = 1016) as 'EPN', 
	(select count() from eau eauLV where eau.c_zk=eauLV.c_zk and eauLV.c_up = 13 and eauLV.dt_ur<20171001) as 'LV' 
FROM eau 
WHERE c_up IN (13, 1016) and xcnull(ind_nepl)<>'A' and c_zk IN ( -- individual cases );


-- Look for cases with a principal amount higher than 250 000 Kc
SELECT c_zk, 
	sum(f_castka) as 'Jistina' 
FROM eaf
WHERE f_typ='J' and exists(select * from eaz where eaz.c_zk=eaf.c_zk and xcnull(eaz.IND_AKTIV)<>'N')
GROUP BY c_zk
HAVING sum(f_castka)>250000;
