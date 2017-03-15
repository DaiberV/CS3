DECLARE @ImpCod CHAR(10) = 'IPU';
DECLARE @PeriodCod INT = 2017;

DECLARE @aPeriodCod INT = (SELECT MAX([PeriodCod]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] < @PeriodCod);
DECLARE @aVgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] < @PeriodCod);
DECLARE @VgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] = @PeriodCod);
DECLARE @aCptCod CHAR(10) = (SELECT MAX([ImpCptCap01]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);

SELECT
	prd.[PrdRef]			as [Referencia Catastral]
	,prd.[PrdPrpNom]		as [Propietario Titular]
	,prd.[PrdDir]			as [Direccion]
	,avla.[PrdVigAvl]		as [Avaluo Anterior]
	,tpra.[TprNom]			as [Tipo Anterior]
	,dsta.[DstNom]			as [Destino Anterior]
	,cpra.[CprNom]			as [Clase Anterior]
	,avl.[PrdVigAvl]		as [Avaluo Actual]
	,tpr.[TprNom]			as [Tipo Actual]
	,dst.[DstNom]			as [Destino Actual]
	,cpr.[CprNom]			as [Clase Actual]
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
LEFT JOIN
	[PRD_Tipo] as tpr
	ON avl.[PrdVigTprCod] = tpr.[TprCod]
LEFT JOIN
	[PRD_Destino] as dst
	ON avl.[PrdVigDstCod] = dst.[DstCod]
LEFT JOIN
	[PRD_Estrato] as esta
	ON avla.[PrdVigEstCod] = esta.[EstCod]
LEFT JOIN
	[PRD_Clase] as cpra
	ON avl.[PrdVigCprCod] = cpra.[CprCod]
LEFT JOIN
	[PRD_Tipo] as tpra
	ON avla.[PrdVigTprCod] = tpra.[TprCod]
LEFT JOIN
	[PRD_Destino] as dsta
	ON avla.[PrdVigDstCod] = dsta.[DstCod]
LEFT JOIN
	[PRD_Estrato] as est
	ON avl.[PrdVigEstCod] = est.[EstCod]
LEFT JOIN
	[PRD_Clase] as cpr
	ON avl.[PrdVigCprCod] = cpr.[CprCod]
WHERE
	prd.[ImpCod] = @ImpCod
	and (
	ISNULL(dst.[DstCod],'') <> ISNULL(dsta.[DstCod],'')
	or ISNULL(est.[EstCod],'') <> ISNULL(esta.[EstCod],'')
	or ISNULL(cpr.[CprCod],'') <> ISNULL(cpra.[CprCod],'')
	)
	