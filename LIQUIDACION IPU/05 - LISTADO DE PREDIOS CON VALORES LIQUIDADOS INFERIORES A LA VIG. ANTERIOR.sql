DECLARE @ImpCod CHAR(10) = @iImpCod;
DECLARE @PeriodCod INT = @iPeriodCod;
DECLARE @Diferencias CHAR(20) = @iDiferencias;

DECLARE @aPeriodCod INT = (SELECT MAX([PeriodCod]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] < @PeriodCod);
DECLARE @aVgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] < @PeriodCod);
DECLARE @VgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] = @PeriodCod);
DECLARE @aCptCod CHAR(10) = (SELECT MAX([ImpCptCap01]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);

SELECT
	prd.[PrdRef]			as [Referencia Catastral]
	,prd.[PrdPrpNom]		as [Propietario Titular]
	,prd.[PrdDir]			as [Direccion]
	,tpr.[TprNom]			as [Tipo]
	,dst.[DstNom]			as [Destino]
	,avla.[PrdVigAvl]		as [Avaluo Anterior]
	,gg.[SxcTar]			as [Tarifa Anterior]
	,gg.[SxcFac]			as [Liquidacion Anterior]
	,avl.[PrdVigAvl]		as [Avaluo Actual]
	,tt.[SxcTar]			as [Tarifa Actual]
	,tt.[SxcFac]			as [Liquidacion Actual]
	,gg.[SxcFac] - tt.[SxcFac]	as [Diferencia]
FROM
	[IMP_Contribuyente] as prd
INNER JOIN
	[PRD_Avaluo] as avl
	ON prd.[ImpCod] = avl.[ImpCod]
	and prd.[CntCod] = avl.[CntCod]
	and avl.[VigCod] = @VgfCod
INNER JOIN
	[PRD_Avaluo] as avla
	ON prd.[ImpCod] = avla.[ImpCod]
	and prd.[CntCod] = avla.[CntCod]
	and avla.[VigCod] = @aVgfCod
INNER JOIN
	(
	SELECT
			mov.[ImpCod]
			,mov.[MovCod]
			,mdet.[CptCod]
			,MAX(mdet.[MdetTfaItm]) as [TfaItem]
			,MAX(mov.[CntCod]) as [CntCod]
			,MAX(mdet.[MdetTar])	as [SxcTar]
			,SUM(mdet.[MdetBase])	as [SxcBase]
			,SUM(mdet.[MdetFac])	as [SxcFacBrt]
			,SUM(mdet.[MdetFac]+mdet.[MdetDeb]-mdet.[MdetCrd]-mdet.[MdetPag]) as [SxcFac]
			,MAX(mdet.[MdetLim])	as [SxcLim]
			,MAX(mdet.[MdetLimFct]) as [SxcLimFct]
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
			,mov.[MovCod]
			,mdet.[CptCod]
	
	) as tt
	ON tt.[ImpCod] = prd.[ImpCod]
	and tt.[CntCod] = prd.[CntCod]
INNER JOIN
	(
	SELECT
			mov.[ImpCod]
			,mov.[MovCod]
			,mdet.[CptCod]
			,MAX(mdet.[MdetTfaItm]) as [TfaItem]
			,MAX(mov.[CntCod]) as [CntCod]
			,MAX(mdet.[MdetTar])	as [SxcTar]
			,SUM(mdet.[MdetBase])	as [SxcBase]
			,SUM(mdet.[MdetFac])	as [SxcFacBrt]
			,SUM(mdet.[MdetFac]+mdet.[MdetDeb]-mdet.[MdetCrd]-mdet.[MdetPag]) as [SxcFac]
			,MAX(mdet.[MdetLim])	as [SxcMdetLim]
			,MAX(mdet.[MdetLimFct]) as [SxcMdetLimFct]
		FROM
			[IMP_Movimiento] as mov
		INNER JOIN
			[IMP_MovimientoDetalle] as mdet
			ON mdet.[ImpCod] = mov.[ImpCod]
			and mdet.[MovCod] = mov.[MovCod]
		WHERE
			mov.[ImpCod] = @ImpCod
			and mdet.[PeriodCod] = @aPeriodCod
			and mdet.[CptCod] = @aCptCod
			and mov.[MovTip] = 'CAUSACION'
			and mov.[MovEst] = 1
		GROUP BY
			mov.[ImpCod]
			,mov.[MovCod]
			,mdet.[CptCod]
	
	) as gg
	ON gg.[ImpCod] = prd.[ImpCod]
	and gg.[CntCod] = prd.[CntCod]
LEFT JOIN
	[PRD_Tipo] as tpr
	ON avl.[PrdVigTprCod] = tpr.[TprCod]
LEFT JOIN
	[PRD_Destino] as dst
	ON avl.[PrdVigDstCod] = dst.[DstCod]
LEFT JOIN
	[PRD_Tipo] as tpra
	ON avla.[PrdVigTprCod] = tpra.[TprCod]
LEFT JOIN
	[PRD_Destino] as dsta
	ON avla.[PrdVigDstCod] = dsta.[DstCod]
WHERE
	((prd.[ImpCod] = @ImpCod
	AND (@Diferencias = 'SI' ))
	OR
	(prd.[ImpCod] = @ImpCod
	 AND @Diferencias = 'NO' 
	 AND gg.[SxcFac] > tt.[SxcFac]))