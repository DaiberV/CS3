DECLARE @ImpCod char(5) = 'IPU';

SELECT
	ROW_NUMBER()OVER(ORDER BY cnt.CntCod)		as  [No.]
	,cnt.CntCod									as	[REFERENCIA CATASTRAL]
	,MAX(cnt.CntNom)							as	[PROPIETARIO TITULAR]
	,MAX(cnt.CntDir)							as	[DIRECCION]
	,MAX(tip.TprNom)							as	[TIPO]
	,MAX(dst.DstNom)							as	[DESTINO]
	,MAX(cnt.PrdAvlVig)							as	[ULTIMA VIGENCIA LIQUIDADA]
	,COUNT(distinct det.PeriodCod)				as	[No. DE VIGEMCIAS EN DEUDA]
	,SUM(det.SxcSdo)							as	[VLR. DEUDA]
	
FROM
		IMP_Contribuyente as cnt
	INNER JOIN 
		IMP_CarteraDetalle as  det
		on cnt.ImpCod	= det.ImpCod
		and cnt.CntCod	= det.CntCod
	INNER JOIN
		PRD_Tipo as tip
		on tip.TprCod = cnt.TprCod
	INNER JOIN
		PRD_Destino as dst
		on dst.DstCod = cnt.DstCod
	
Where
	cnt.ImpCod = @ImpCod
	and cnt.CntEst = 0
	and det.SxcSdo > 0
GROUP BY
	cnt.CntCod