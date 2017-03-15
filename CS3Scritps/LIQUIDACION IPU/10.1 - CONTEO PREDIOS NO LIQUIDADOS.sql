DECLARE	@PeriodCod numeric(4) = 2017;
DECLARE @PlqCod numeric (4) = 1;
SELECT 
	COUNT(mov1.MovCod) as [NUMERO_LIQUIDADOS]
FROM
	IMP_Movimiento AS mov1

inner join
(SELECT 
	 MAX(mov.CntCod)	as [CntCod]
	,MAX(mov.MovTip)	as [MovTip]
	,det.MovCod			as [MovCod]
FROM
	IMP_Movimiento	as mov
	INNER JOIN  IMP_MovimientoDetalle as det
	on mov.ImpCod = det.ImpCod and
	mov.MovCod = det.MovCod
	INNER JOIN PRD_ClasificacionPredio as cls
	on cls.IgcPrdRef = mov.CntCod
	
Where 
		mov.MovTip = 'CAUSACION'
	and mov.MovEst = 1
	and mov.ImpCod = 'IPU'
	and	det.PeriodCod = @PeriodCod
	and cls.PlqCod    = @PlqCod
Group by
	mov.MovTip
	,det.MovCod
) as tt
on tt.MovCod = mov1.MovCod
GROUP BY
	mov1.ImpCod