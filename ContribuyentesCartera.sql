WITH tt AS (
SELECT
	 cnt.ImpCod
	,cnt.CntCod
	,MAX(cnt.CntNit)				as [CntNit]
	,ISNULL(MAX(cnt.CntMatMerc),'')	as [CntMatMerc]
	,MAX(cnt.CntRazSoc)				as [CntRazSoc]
	,MAX(est.CntEtbNom)				as [CntEtbNom]
	,ISNULL(MAX(est.CntEtbRef),'')	as [CntEtbRef]
	,MAX(Case
		When cnt.CntRepLegTip = 'REP_LEGAL'
			Then 'REPRESENTANTE LEGAL'
		When cnt.CntRepLegTip = 'PROPIETARIO'
			Then 'PROPIETARIO'
		Else
			''
	 End)											as [CntRepLegTip]
	,LTRIM(RTRIM(ISNULL(MAX(cnt.CntRepLegNom),'')))	as [CntRepLegNom]
	,ISNULL(MAX(est.CntEtbDir),'')					as [CntEtbDir]
	,ISNULL(MAX(cnt.CntNotTel),'')					as [CntNotTel]
FROM
	IMP_Contribuyente as cnt
INNER JOIN 
	ICA_ContribuyenteEstab as est
	on cnt.ImpCod = est.ImpCod
	and cnt.CntCod =  est.CntCod
WHERE
	cnt.ImpCod = 'RETEICAT' AND
	cnt.CntEst = 1
GROUP BY
	 cnt.ImpCod
	,cnt.CntCod
)
, gg AS (
SELECT
	 car.ImpCod				AS [ImpCod]
	,car.CntCod				AS [CntCod]
	,car.PeriodCod			AS [PeriodCod]
	,MAX(ano.PeriodNom)		AS [PeriodNom]
	,SUM(det.SxcFac-det.SxcPag-det.SxcCrd+det.SxcDeb) AS [ESTADO]
	,MAX(tt.[CntMatMerc])		AS [CntMatMerc]
	,MAX(tt.CntEtbDir)		AS [CntEtbDir]
	,MAX(tt.CntEtbNom)		AS [CntEtbNom]
	,MAX(tt.CntEtbRef)		AS [CntEtbRef]
	,MAX(tt.CntNit)			AS [CntNit]
	,MAX(tt.CntNotTel)		AS [CntNotTel]
	,MAX(tt.CntRazSoc)		AS [CntRazSoc]
	,MAX(tt.CntRepLegNom)	AS [CntRepLegNom]
	,MAX(tt.CntRepLegTip)	AS [CntRepLegTip]
	
FROM
	tt
INNER JOIN
	IMP_Cartera AS car
	ON tt.ImpCod = car.ImpCod
	and tt.CntCod = car.CntCod
INNER JOIN
	IMP_CarteraDetalle AS det
	ON car.ImpCod = det.ImpCod
	and car.CntCod = det.CntCod
	and car.PeriodCod = det.PeriodCod
INNER JOIN
	IMP_Periodo as ano
	ON car.ImpCod = ano.ImpCod
	and car.PeriodCod = ano.PeriodCod
GROUP BY
	car.ImpCod
	,car.CntCod
	,car.PeriodCod
)
SELECT
	 gg.CntMatMerc	as [No. MATRICULA]
	,gg.CntNit		as [NIT]
	,gg.CntRazSoc	as [RAZON SOCIAL]
	,gg.CntEtbNom	as [NOMBRE ESTABLECIMIENTO]
	,gg.CntEtbDir	as [DIRECCION DEL ESTABLECIMEINTO]
	,gg.PeriodNom	as [PERIODO]
	,gg.ESTADO		as [VALOR]
	,CASE
		WHEN gg.ESTADO = 0
			THEN 'PAGADO'
		ELSE
			'MOROSO'
	END		as [ESTADO FINANCIERO]

FROM
	gg
where
	gg.CntNit = 900804597           
ORDER BY
	gg.CntCod