DECLARE @ImpCod CHAR(10) = @iImpCod;
DECLARE @PeriodCod INT = @iPeriodCod;
DECLARE @TprCod CHAR(10) = @iTprCod;


DECLARE @VgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] = @PeriodCod);
DECLARE @aCptCod CHAR(10) = (SELECT MAX([ImpCptCap01]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);
DECLARE @bCptCod CHAR(10) = (SELECT MAX([ImpCptCap02]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);
DECLARE @cCptCod CHAR(10) = (SELECT MAX([ImpCptCap03]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);


SELECT
	RTRIM(LTRIM(dst.[DstCod]))
	+' : '
	+RTRIM(LTRIM(dst.[DstNom]))	as [Destino]
	,[N° Predios]
	,[N° Liquidados]
	,[N° Sin Liquidar]
	,[Vlr A]
	,[Vlr B]
	,[Vlr C]
FROM
(
	SELECT
		avl.[PrdVigDstCod]				as [DstCod]
		,COUNT(*)						as [N° Predios]
		,COUNT(tt.[aSxcFac])			as [N° Liquidados]
		,COUNT(*)-COUNT(tt.[aSxcFac])	as [N° Sin Liquidar]
		,ISNULL(SUM(tt.[aSxcFac]),0)				as [Vlr A]
		,ISNULL(SUM(tt.[bSxcFac]),0)				as [Vlr B]
		,ISNULL(SUM(tt.[cSxcFac]),0)				as [Vlr C]
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
			,mov.[CntCod] as [CntCod]
			,SUM(
				CASE
					WHEN mdet.[CptCod] = @aCptCod THEN
						mdet.[MdetFac]+mdet.[MdetDeb]-mdet.[MdetCrd]-mdet.[MdetPag]
				END
			)				as [aSxcFac]
			,SUM(
				CASE
					WHEN mdet.[CptCod] = @bCptCod THEN
						mdet.[MdetFac]+mdet.[MdetDeb]-mdet.[MdetCrd]-mdet.[MdetPag]
				END
			)				as [bSxcFac]
			,SUM(
				CASE
					WHEN mdet.[CptCod] = @cCptCod THEN
						mdet.[MdetFac]+mdet.[MdetDeb]-mdet.[MdetCrd]-mdet.[MdetPag]
				END
			)				as [cSxcFac]
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
			and mov.[MovTip] = 'CAUSACION'
			and mov.[MovEst] = 1
		GROUP BY
			mov.[ImpCod]
			,mov.[CntCod]
	) as tt	
		ON tt.[ImpCod] = prd.[ImpCod]
		and tt.[CntCod] = prd.[CntCod]
	WHERE
		prd.[ImpCod] = @ImpCod
		and avl.[VigCod] = @VgfCod
	GROUP BY
		avl.[PrdVigDstCod]
) as tt
INNER JOIN
	[PRD_Destino] as dst
	ON tt.[DstCod] = dst.[DstCod]