DECLARE @ImpCod CHAR(10) = 'IPU';
DECLARE @PeriodCod INT = 2017;


DECLARE @VgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] = @PeriodCod);
DECLARE @aCptCod CHAR(10) = (SELECT MAX([ImpCptCap01]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);
DECLARE @bCptCod CHAR(10) = (SELECT MAX([ImpCptCap02]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);
DECLARE @cCptCod CHAR(10) = (SELECT MAX([ImpCptCap03]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);


SELECT
	TOP 100
	*
FROM
(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY prd.[TprCod], prd.[DstCod], prd.[CprCod] ORDER BY NEWID() ) as [RANK]
		,prd.[PrdRef]						as [Referencia Catastral]
		,prd.[PrdPrpNom]					as [Propietario Titular]
		,prd.[PrdDir]						as [Direccion]
		,tpr.[TprNom]						as [Tipo]
		,dst.[DstNom]						as [Destino]
		,ISNULL(est.EstCod,'-')				as [ESTRATO]
		,ISNULL(cpr.[CprNom],'-')			as [Clase]
		,avl.[PrdVigAvl]					as [Avaluo]
		,tt.[aSxcTar]						as [Tar A]
		,tt.[aSxcFac]						as [Vlr A]
		,tt.[bSxcFac]						as [Vlr B]
		,tt.[cSxcFac]						as [Vlr C]
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
			mov.[ImpCod]
			,mov.[MovCod]
			,MAX(mov.[CntCod]) as [CntCod]
			,MAX(
				CASE
					WHEN mdet.[CptCod] = @aCptCod THEN mdet.[MdetTar]
				END)					as [aSxcTar]
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
			,mov.[MovCod]
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
	LEFT JOIN
		[PRD_Clase] as cpr
		ON avl.[PrdVigCprCod] = cpr.[CprCod]
	WHERE
		prd.[ImpCod] = @ImpCod
) as gg
ORDER BY
	[RANK]
