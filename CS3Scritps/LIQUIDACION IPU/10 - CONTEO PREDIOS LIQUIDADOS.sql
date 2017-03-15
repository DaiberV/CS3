DECLARE	@PeriodCod numeric(4) = 2017;
DECLARE @PlqCod numeric (4) = 1;
SELECT 
	COUNT(cnt.CntCod) as [NUMERO_NO_LIQUIDADOS]
FROM
	IMP_Contribuyente AS cnt

INNER JOIN
(
SELECT 
	 prd.IgcPrdRef
	FROM PRD_ProcesoLiquidacion as lq
	
	INNER JOIN PRD_Clasificacion AS cls
	
	on lq.ImpCod = cls.ImpCod
	and lq.PlqCod = cls.PlqCod
	
	INNER JOIN PRD_ClasificacionPredio as prd
	
	on cls.ImpCod = prd.ImpCod
	and cls.PlqCod = prd.PlqCod
	and cls.PlqClsItm = prd.PlqClsItm
	
	Where 
	lq.IgcVgfCod = @PeriodCod 
	and prd.PlqCod=  @PlqCod
	GROUP BY
	prd.IgcPrdRef
	EXCEPT

(SELECT 
	 MAX(mov.CntCod)	as [CntCod]
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
Group by
	det.MovCod)
)
	as tt
on tt.IgcPrdRef = cnt.CntCod
GROUP BY
	cnt.ImpCod