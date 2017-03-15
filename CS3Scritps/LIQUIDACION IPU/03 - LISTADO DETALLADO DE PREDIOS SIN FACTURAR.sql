DECLARE @ImpCod CHAR(10) = 'IPU';
DECLARE @PeriodCod INT = 2017;

DECLARE @VgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] = @PeriodCod);
DECLARE @aCptCod CHAR(10) = (SELECT MAX([ImpCptCap01]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);

SELECT
	prd.[PrdRef]			as [Referencia Catastral]
	,prd.[PrdPrpNom]		as [Propietario Titular]
	,prd.[PrdDir]			as [Direccion]
	,tpr.[TprNom]			as [Tipo]
	,dst.[DstNom]			as [Destino]
	,est.[EstNom]			as [Estrato]
	,avl.[PrdVigAvl]		as [Avaluo]
FROM
	[IMP_Contribuyente] as prd
INNER JOIN
	[PRD_Avaluo] as avl
	ON prd.[ImpCod] = avl.[ImpCod]
	and prd.[CntCod] = avl.[CntCod]
	and avl.[VigCod] = @VgfCod
INNER JOIN
	(
		SELECT
			prd.[ImpCod]
			,prd.[CntCod]
		FROM
			[IMP_Contribuyente] as prd
		INNER JOIN
			[PRD_Avaluo] as avl
			ON prd.[ImpCod] = avl.[ImpCod]
			and prd.[CntCod] = avl.[CntCod]
			and avl.[VigCod] = @VgfCod
		WHERE
			prd.[ImpCod] = @ImpCod
		EXCEPT
		SELECT
			mov.[ImpCod]
			,mov.[CntCod]
		FROM
			[IMP_Movimiento] as mov
		INNER JOIN
			[IMP_MovimientoDetalle] as mdet
			ON mdet.[ImpCod] = mov.[ImpCod]
			and mdet.[MovCod] = mov.[MovCod]
		WHERE
			mov.[ImpCod] = @ImpCod
			and mdet.[PeriodCod] = @PeriodCod
			and mdet.[CptCod] = @aCptCod
			and mov.[MovTip] = 'CAUSACION'
			and mov.[MovEst] = 1
		GROUP BY
			mov.[ImpCod]
			,mov.[CntCod]	
	) as tt
	ON tt.[ImpCod] = prd.[ImpCod]
	and tt.[CntCod] = prd.[CntCod]
LEFT JOIN
	[PRD_Tipo] as tpr
	ON avl.[PrdVigTprCod] = tpr.[TprCod]
LEFT JOIN
	[PRD_Destino] as dst
	ON avl.[PrdVigDstCod] = dst.[DstCod]
LEFT JOIN
	[PRD_Estrato] as est
	ON avl.[PrdVigEstCod] = est.[EstCod]
WHERE
	prd.[ImpCod] = @ImpCod