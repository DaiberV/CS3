DECLARE @ImpCod CHAR(10) = 'IPU';
DECLARE @PlqCod INT = ISNULL((SELECT MAX([PlqCod]) FROM [PRD_ProcesoLiquidacion] WHERE [ImpCod] = @ImpCod ),0);

INSERT INTO [IGC_Vigencia]
	(
	[IgcVgfCod]
	,[IgcNum01]
	,[IgcNum02]
	,[IgcEst]
	)
SELECT
	[PeriodAnho]
	,0
	,0
	,'MIGRADO'
FROM
(
	SELECT
		[ImpCod]
		,[PeriodCod]
		,[PeriodAnho]
	FROM
		[IMP_Periodo]
	WHERE
		[ImpCod] = @ImpCod
		and [PeriodEst] = 1
	EXCEPT
	SELECT
		[ImpCod]
		,[PeriodCod]
		,[IgcVgfCod]
	FROM
		[PRD_ProcesoLiquidacion]
	WHERE
		[ImpCod] = @ImpCod
) as tt;