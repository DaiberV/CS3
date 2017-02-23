DECLARE @ImpCod char(10)= 'ICAT';

SELECT
	ISNULL(cnt.CntNit,'')		as [NIT]
	,ISNULL(cnt.CntRazSoc,'')	as [RAZON SOCIAL]
	,ISNULL(est.CntEtbNom,'')		as [NOMBRE ESTABLECIMIENTO]
	,ISNULL(est.CntEtbRef,'')	as [PLACA]
	,Case
		When cnt.CntRepLegTip = 'REP_LEGAL'
			Then 'REPRESENTANTE LEGAL'
		When cnt.CntRepLegTip = 'PROPIETARIO'
			Then 'PROPIETARIO'
		Else
			''
	 End										as [TIPO DE PROPIETARIO]
	,LTRIM(RTRIM(ISNULL(cnt.CntRepLegNom,'')))	as [NOMBRE]
	,ISNULL(est.CntEtbDir,'')					as [DIRECCION DEL ESTABLECIMIENTO]
	,ISNULL(cnt.CntNotTel,'')					as [TELEFONO]
FROM
	IMP_Contribuyente as cnt
INNER JOIN ICA_ContribuyenteEstab as est
	on cnt.ImpCod = est.ImpCod
	and cnt.CntCod =  est.CntCod
Where 
	cnt.ImpCod = @ImpCod
	--and cnt.CntNit = '1085269174'