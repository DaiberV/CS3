######################################1111111111111111##################################

declare @vgfCod char(4) = '2016';
SELECT
	ISNULL(dst.DstCod,0)						AS [CODIGO]
	,ISNULL(MAX(dest.DstNom),'NO ASIGNADO')		AS [DESTINO]
	,COUNT(prd.IgcPrdRef)						AS [No. Predios]
FROM
	IGC_Predio as prd
LEFT JOIN 
	IGC_HomDestino AS dst
	ON dst.DstCod = prd.IgcPrdDst
LEFT JOIN
	PRD_Destino		AS dest
	ON dest.DstCod = dst.DstCod
WHERE 
	prd.IgcVgfCod = @vgfCod
GROUP BY 
	dst.DstCod 
ORDER BY
	dst.DstCod
	
######################################22222222222222222####################################

declare @vgfCod char(4) = '2016';
SELECT 
	id.IgcTidCod	AS TIPO
	,CASE
		WHEN id.IgcTidCod = 'C'
			THEN 'CEDULA DE CIUDADANIA'
		WHEN id.IgcTidCod = 'E'
			THEN 'CEDULA EXTRANJERA'
		WHEN id.IgcTidCod = 'N'
			THEN 'NIT'
		WHEN id.IgcTidCod = 'T'
			THEN 'TARJETA DE IDENTIDAD'
		WHEN id.IgcTidCod = 'X'
			THEN 'NO IDENTIFICADO'
		ELSE
			''
		END					AS	[NOMBRE]
	,COUNT(r1.Igc01Itm)		AS [No. Registros]
FROM
	IGC_HomTipoId AS id
INNER JOIN
	IGC_Vigencia AS vg
on vg.IgcVgfCod = id.IgcVgfCod
INNER JOIN 
	IGC_Registro01 AS r1
	on r1.IgcVgfCod = vg.IgcVgfCod
	AND	r1.Igc01PrpTip = id.IgcTidCod
WHERE
	vg.IgcVgfCod = @vgfCod
GROUP BY
	id.IgcTidCod
	
###########################################33333333333333333333############################################

declare @vgfCod char(4) = '2016';
SELECT 
	tip.IgcTprCod			AS [CODIGO]
	,MAX(tip.IgcTprNom)		AS [NOMBRE]
	,COUNT(prd.IgcPrdRef)	AS [No. REGISTROS]
FROM
	IGC_HomTipoPredio	AS tip
INNER JOIN
	IGC_Vigencia		AS vg
	on vg.IgcVgfCod = tip.IgcVgfCod
INNER JOIN
	IGC_Predio			AS prd
	on prd.IgcVgfCod = vg.IgcVgfCod
	AND	prd.IgcPrdTpr = tip.IgcTprCod
WHERE
	TIP.IgcVgfCod = @vgfCod
GROUP BY
	tip.IgcTprCod