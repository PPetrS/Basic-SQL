-- Search the database for cases where there is an EPZP or EPZP-man classification 
-- and sort them primarily by debt size and secondarily by date

SELECT  
	eazv.c_zk, 
	date(eazv.t_stam_prn) as 'založeno', 
	eazv.vl as 'klasifikace', 
	xeaQOprS(c_zk) as 'oprávněný', 
	xeanoj(c_zk) as 'jistina' 
FROM eazv 
WHERE eazv.vl IN ('EPZP','EPZP-man') 
AND eazv.ind_pl=1 ORDER BY xeanoj(c_zk) DESC, date(eazv.t_stam_prn);
