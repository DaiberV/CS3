DECLARE @ImpCod CHAR(10) = 'IPU';
DECLARE @PeriodCod INT = 2017;
DECLARE @TprCod CHAR(10) = '';


DECLARE @VgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] = @PeriodCod);
DECLARE @aCptCod CHAR(10) = (SELECT MAX([ImpCptCap01]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);


SELECT
	RTRIM(LTRIM(dst.[DstCod]))
	+' : '
	+RTRIM(LTRIM(MAX(dst.[DstNom])))	as [Destino]
	,COUNT(*)						as [N° Predios]
	,COUNT(tt.[SxcFac])				as [N° Liquidados]
	,COUNT(*)-COUNT(tt.[SxcFac])	as [N° Sin Liquidar]
	,ISNULL(MAX(tdet.[TfaBseIni]),0)			as [Base Inicial]
	,ISNULL(MAX(tdet.[TfaBseFin]),0)			as [Base Final]
	,ISNULL(MAX(tdet.[TfaVlrPrc]),0)			as [Tarifa]
	,ISNULL(SUM(avl.[PrdVigAvl]),0)				as [Suma Avaluos]
	,ISNULL(SUM(tt.[SxcFac]),0)				as [Valor Liquidado]
FROM
	[IMP_Contribuyente] as prd
INNER JOIN
	[PRD_Avaluo] as avl
	ON prd.[ImpCod] = avl.[ImpCod]
	and prd.[CntCod] = avl.[CntCod]
LEFT JOIN
(
	SELECT
		mov.[ImpCod]
		,mov.[MovCod]
		,mdet.[CptCod]
		,MAX(mdet.[MdetTfaItm]) as [TfaItem]
		,MAX(mov.[CntCod]) as [CntCod]
		,SUM(mdet.[MdetBase])	as [SxcBase]
		,SUM(mdet.[MdetFac]+mdet.[MdetDeb]-mdet.[MdetCrd]-mdet.[MdetPag]) as [SxcFac]
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
	[PRD_Tipo] as tpr
	ON avl.[PrdVigTprCod] = tpr.[TprCod]
INNER JOIN
	[PRD_Destino] as dst
	ON avl.[PrdVigDstCod] = dst.[DstCod]
LEFT JOIN
	[IMP_Tarifa] as tar
	ON tar.[ImpCod] = prd.[ImpCod]
	and tar.[VgfCod] = @VgfCod
	and tar.[TfaCptCod] = tt.[CptCod]
LEFT JOIN
	[IMP_TarifaDetalle] as tdet
	ON tar.[ImpCod] = tdet.[ImpCod]
	and tar.[VgfCod] = tdet.[VgfCod]
	and tar.[TfaCptCod] = tdet.[TfaCptCod]
	and tdet.[TfaItem] = tt.[TfaItem]
WHERE
	prd.[ImpCod] = @ImpCod
	and avl.[VigCod] = @VgfCod
	and (tpr.[TprCod] = @TprCod or @TprCod='')
GROUP BY
	dst.[DstCod]
	,tdet.[TfaItem]
ORDER BY
	MAX(ISNULL(tdet.[TfaOrd],999))