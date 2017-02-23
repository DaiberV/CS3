DECLARE @ImpCod CHAR(10) = 'IPU';
DECLARE @PlqCod INT = ISNULL((SELECT MAX([PlqCod]) FROM [PRD_ProcesoLiquidacion] WHERE [ImpCod] = @ImpCod ),0);

INSERT INTO [PRD_ProcesoLiquidacion]
	(
		[ImpCod]
		,[PlqCod]
		,[PeriodCod]
		,[IgcVgfCod]
		,[PlqIncl]
		,[PlqEst]
	)	
SELECT
	[ImpCod]		as [ImpCod]
	,@PlqCod + ROW_NUMBER() OVER(ORDER BY [ImpCod], [PeriodCod]) as 	[PlqCod]
	,[PeriodCod]	as [PeriodCod]
	,[PeriodAnho]	as [IgcVgfCod]
	,0				as [PlqIncl]
	,'MIGRADO'		as [PlqEst]
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
) as tt