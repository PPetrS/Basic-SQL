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
