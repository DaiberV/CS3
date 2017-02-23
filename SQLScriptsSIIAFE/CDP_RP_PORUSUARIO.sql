/*RP*/
SELECT
	CONVERT(varchar(4),cab.AnoCod)+'.'+'ALC.'+CONVERT(VARCHAR(5),MAX(cab.ResId2))+'.'+CONVERT(VARCHAR(5),MAX(cab.ResId)) AS [CONSECUTIVO VISUAL]
	,MAX(cab.ResId)		AS [CONSECUTIVO]
	,MAX(cab.ResFec)	AS [FECHA ELABORACION]
	,MAX(cab.ResDes)	AS [DESCRIPCION]
	,MAX(cab.ResUsuEla)	AS [USUARIO ELABORADOR]
	,SUM(det.ResDetVlr)	AS [VALOR]
FROM
	PPG_RP AS cab
INNER JOIN
	PPG_RPDet AS det
	ON cab.AnoCod = det.AnoCod
	and cab.ResCod = det.ResCod
WHERE
	(cab.AnoCod = 2016 or cab.AnoCod = 2017)
	and cab.ResUsuEla = 'ADMINISTRADOR'
GROUP BY
	cab.ResCod
	,cab.AnoCod

/*CDP*/
SELECT
	CONVERT(varchar(4),cd.AnoCod)+'.'+'ALC.'+CONVERT(VARCHAR(5),MAX(cd.CdpId2))+'.'+CONVERT(VARCHAR(5),MAX(cd.CdpId)) AS [CONSECUTIVO VISUAL]
	,MAX(cd.CdpId)		AS [CONSECUTIVO]
	,MAX(cd.CdpFec)		AS [FECHA]
	,MAX(cd.CdpDes)		AS [DESCRIPCION]
	,MAX(cd.CdpUsuEla)	AS [USUARIO ELABORADOR]
	,SUM(det.CdpDetVlr)	AS [VALOR]
FROM
	PPG_CDP as cd
INNER JOIN
	PPG_CDPDet as det
	ON det.AnoCod = cd.AnoCod
	and det.CdpCod = cd.CdpCod
WHERE
	(cd.AnoCod = 2016 OR cd.AnoCod = 2017)
GROUP BY
	cd.CdpCod
	,cd.AnoCod