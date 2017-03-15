DECLARE @ImpCod CHAR (10) = 'IPU';
DECLARE @PeriodCod INT = 2017;

DECLARE @VgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] = @PeriodCod);
DECLARE @aCptCod CHAR(10) = (SELECT MAX([ImpCptCap01]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);
DECLARE @bCptCod CHAR(10) = (SELECT MAX([ImpCptCap02]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);
DECLARE @cCptCod CHAR(10) = (SELECT MAX([ImpCptCap03]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);

SELECT TOP 100
	--ee.[REFERENCIA CATASTRAL],
	--ee.[PROPIETARIO TITULAR],
	--ee.DIRECCION,
	--ee.[VLR LIQUIDADO]
	*
FROM(
SELECT
	ROW_NUMBER() OVER(PARTITION BY cnt.[TprCod], cnt.[DstCod], cnt.[CprCod] ORDER BY NEWID() ) as [RANK],
	cnt.CntCod								as [REFERENCIA CATASTRAL],
	cnt.CntNom								as [PROPIETARIO TITULAR],
	cnt.CntDir								as [DIRECCION],
	tip.TprNom								as [TIPO],
	dst.DstNom								as [DESTINO],
	cpt.CptNom								as [CONCEPTO A],
	tt.SxcBase								as [BASE LIQUIDADA A],
	(tdet.TfaVlrPrc/tdet.TfaVlrTip)			as [%Tarifa A],
	tt.SxcFacBrt							as [VLR LIQUIDADO A],
	Bcpt.CptNom								as [CONCEPTO B],
	gg.SxcBase								as [BASE LIQUIDADA B],
	(Btdet.TfaVlrPrc/Btdet.TfaVlrTip)		as [%Tarifa B],
	gg.[SxcFacBrt]							as [VLR LIQUIDADO B],
	Ccpt.CptNom								as [CONCEPTO C],
	ww.SxcBase								as [BASE LIQUIDADA C],
	(Ctdet.TfaVlrPrc/Ctdet.TfaVlrTip)		as [%Tarifa C],
	ww.SxcFacBrt							as [VLR LIQUIDADO C]
	
FROM
		IMP_Contribuyente AS cnt
	INNER JOIN 
		PRD_Avaluo as avl
		on avl.ImpCod		= cnt.ImpCod
		and avl.CntCod		= cnt.CntCod
		and avl.VigCod		= @VgfCod
	LEFT JOIN
		(
	SELECT
		mov.[ImpCod]
		,mov.[MovCod]
		,mdet.[CptCod]
		,MAX(mdet.[MdetTfaItm]) as [TfaItem]
		,MAX(mov.[CntCod]) as [CntCod]
		,SUM(mdet.[MdetBase])	as [SxcBase]
		,MAX(mdet.MdetFac)		as [SxcFacBrt]
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
		and mdet.[CptCod] = @aCptCod
		and mov.[MovTip] = 'CAUSACION'
		and mov.[MovEst] = 1
	GROUP BY
		mov.[ImpCod]
		,mov.[MovCod]
		,mdet.[CptCod]
) as tt 
		on
		cnt.CntCod	= tt.CntCod
		and cnt.ImpCod = tt.ImpCod
LEFT JOIN
	(
	SELECT
		mov.[ImpCod]
		,mov.[MovCod]
		,mdet.[CptCod]
		,MAX(mdet.[MdetTfaItm]) as [TfaItem]
		,MAX(mov.[CntCod]) as [CntCod]
		,SUM(mdet.[MdetBase])	as [SxcBase]
		,MAX(mdet.MdetFac)		as [SxcFacBrt]
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
		and mdet.[CptCod] = @bCptCod
		and mov.[MovTip] = 'CAUSACION'
		and mov.[MovEst] = 1
	GROUP BY
		mov.[ImpCod]
		,mov.[MovCod]
		,mdet.[CptCod]
) as gg
on gg.CntCod = cnt.CntCod
and gg.ImpCod = cnt.ImpCod

LEFT JOIN
	(
	SELECT
		mov.[ImpCod]
		,mov.[MovCod]
		,mdet.[CptCod]
		,MAX(mdet.[MdetTfaItm]) as [TfaItem]
		,MAX(mov.[CntCod]) as [CntCod]
		,SUM(mdet.[MdetBase])	as [SxcBase]
		,MAX(mdet.MdetFac)		as [SxcFacBrt]
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
		and mdet.[CptCod] = @cCptCod
		and mov.[MovTip] = 'CAUSACION'
		and mov.[MovEst] = 1
	GROUP BY
		mov.[ImpCod]
		,mov.[MovCod]
		,mdet.[CptCod]
) as ww
	on ww.CntCod = cnt.CntCod
	and ww.ImpCod	 = cnt.ImpCod
	
	INNER JOIN
		PRD_Tipo as tip
		on tip.TprCod = avl.PrdVigTprCod
	INNER JOIN
		PRD_Destino as dst
		on dst.DstCod = avl.PrdVigDstCod
	LEFT JOIN
		IMP_Tarifa as tar
		on tar.ImpCod		= cnt.ImpCod
		and tar.VgfCod		= @VgfCod
		and tar.TfaCptCod	= tt.CptCod
	LEFT JOIN
		IMP_TarifaDetalle as tdet
		ON tar.[ImpCod]		= tdet.[ImpCod]
		and tar.[VgfCod]	= tdet.[VgfCod]
		and tar.[TfaCptCod] = tdet.[TfaCptCod]
		and tdet.[TfaItem]	= tt.[TfaItem]
	LEFT JOIN
		IMP_Concepto as cpt
		on tt.ImpCod  = cpt.ImpCod
		and tt.CptCod = cpt.CptCod
	LEFT JOIN
		IMP_Tarifa as Btar
		on Btar.ImpCod		= cnt.ImpCod
		and Btar.VgfCod		= @VgfCod
		and Btar.TfaCptCod	= gg.CptCod
	LEFT JOIN
		IMP_TarifaDetalle as Btdet
		ON Btar.[ImpCod]		= Btdet.[ImpCod]
		and Btar.[VgfCod]		= Btdet.[VgfCod]
		and Btar.[TfaCptCod]	= Btdet.[TfaCptCod]
		and Btdet.[TfaItem]		= gg.[TfaItem]
	LEFT JOIN
		IMP_Concepto as Bcpt
		on  gg.ImpCod  = Bcpt.ImpCod
		and gg.CptCod = Bcpt.CptCod
	LEFT JOIN
		IMP_Tarifa as Ctar
		on Ctar.ImpCod		= cnt.ImpCod
		and Ctar.VgfCod		= @VgfCod
		and Ctar.TfaCptCod	= ww.CptCod
	LEFT JOIN
		IMP_TarifaDetalle as Ctdet
		ON Ctar.[ImpCod]		= Ctdet.[ImpCod]
		and Ctar.[VgfCod]		= Ctdet.[VgfCod]
		and Ctar.[TfaCptCod]	= Ctdet.[TfaCptCod]
		and Ctdet.[TfaItem]		= ww.[TfaItem]
	LEFT JOIN
		IMP_Concepto as Ccpt
		on  ww.ImpCod	= Ccpt.ImpCod
		and ww.CptCod	= Ccpt.CptCod
Where 
	cnt.ImpCod = @ImpCod
) AS ee
ORDER BY
	[RANK]
	
