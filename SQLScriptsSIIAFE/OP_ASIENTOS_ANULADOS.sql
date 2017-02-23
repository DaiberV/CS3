WITH BASE AS
(SELECT
	cnt.AnoCod
	,cnt.AsiCod
	,cnt.AsiDes
	,cnt.AsiId
	,cnt.AsiTip
	,cnt.AsiEst
FROM
	CNT_Comprobante as cnt
Where
	cnt.AsiEst = 'ANULADO'
	and cnt.AsiTip = 'OP'
)
SELECT
	MAX(op.PagId)			AS [CONSECUTIVO]
	,MAX(op.PagId2)			AS [SUBCONSECUTIVO]
	,MAX(op.PagEntCod)		AS [ENTIDAD]
	,MAX(op.PagDes)			AS [DESCRIPCION]
	,SUM(det.PagDetVlr)		AS [VALOR]
	,MAX(op.PagEst)			AS [ESTADO ORDEN DE PAGO]
	,MAX(BASE.AsiEst)		AS [ESTADO DEL ASIENTO]
FROM
	BASE
INNER JOIN
	PPG_OP AS op
	ON op.AnoCod = BASE.AnoCod
	and op.PagId = BASE.AsiId
INNER JOIN 
	PPG_OPDet AS det
	on det.AnoCod = op.AnoCod
	and det.PagCod = op.PagCod
WHERE 
	op.PagEst <> 'ANULADO'
GROUP BY
	op.PagCod