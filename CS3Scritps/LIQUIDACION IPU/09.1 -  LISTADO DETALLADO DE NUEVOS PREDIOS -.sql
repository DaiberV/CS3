DECLARE @ImpCod CHAR (10) = 'IPU';
DECLARE @PeriodCod INT = 2017;

DECLARE @VgfCod INT = (SELECT MAX([PeriodAnho]) FROM [IMP_Periodo] WHERE [ImpCod] = @ImpCod and [PeriodCod] = @PeriodCod);
DECLARE @aCptCod CHAR(10) = (SELECT MAX([ImpCptCap01]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);
DECLARE @bCptCod CHAR(10) = (SELECT MAX([ImpCptCap02]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);
DECLARE @cCptCod CHAR(10) = (SELECT MAX([ImpCptCap03]) FROM [IMP_Impuesto] WHERE [ImpCod] = @ImpCod);

SELECT
	cnt.CntCod									as [REFERENCIA CATASTRAL]
	,cnt.CntNom									as [PROPIETARIO TITULAR]
	,MAX(cnt.CntDir)							as [DIRECCION]
	,MAX(tip.TprNom)							as [TIPO]
	,MAX(dst.DstNom)							as [DESTINO]
	,MAX(cpt.CptNom)							as [CONCEPTO A]
	,MAX(tt.ASxcBase)							as [BASE LIQUIDADA A]
	,MAX((tdet.TfaVlrPrc/tdet.TfaVlrTip))		as [%Tarifa A]
	,MAX(tt.ASxcFacBrt)							as [VLR LIQUIDADO]
	,MAX(Bcpt.CptNom)							as [CONCEPTO B]
	,MAX(tt.BSxcBase)							as [BASE LIQUIDADA B]
	,MAX((Btdet.TfaVlrPrc/Btdet.TfaVlrTip))		as [%Tarifa B]
	,MAX(tt.[BSxcFacBrt])						as [VLR LIQUIDADO]
	,MAX(Ccpt.CptNom)							as [CONCEPTO C]
	,MAX(tt.CSxcBase)							as [BASE LIQUIDADA C]
	,MAX((Ctdet.TfaVlrPrc/Ctdet.TfaVlrTip))		as [%Tarifa C]
	,MAX(tt.CSxcFacBrt)							as [VLR LIQUIDADO]
	
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
		,(CASE
			WHEN mdet.[CptCod] = @aCptCod
				THEN mdet.CptCod
		     END)	as ACptCod
		 ,(CASE
			WHEN mdet.CptCod = @bCptCod
				THEN mdet.CptCod
			 END)	as BCptCod
		,(CASE
			WHEN mdet.CptCod =  @cCptCod
				THEN mdet.CptCod
			 END) as CCptCod
		,MAX(mdet.[MdetTfaItm]) as [TfaItem]
		,MAX(mov.[CntCod]) as [CntCod]
		,SUM(CASE
			WHEN mdet.CptCod =  @aCptCod
				THEN mdet.[MdetBase]
			END)	as [ASxcBase]
		,SUM(CASE
			WHEN mdet.CptCod =  @bCptCod
				THEN mdet.[MdetBase]
			END)	as [BSxcBase]
		,SUM(CASE
			WHEN mdet.CptCod =  @cCptCod
				THEN mdet.[MdetBase]
			END)	as [CSxcBase]
		,MAX(CASE
			WHEN mdet.CptCod =  @aCptCod 
				THEN mdet.MdetFac
			END)		as [ASxcFacBrt]
		,MAX(CASE
			WHEN mdet.CptCod =  @bCptCod 
				THEN mdet.MdetFac
			END)		as [BSxcFacBrt]
		,MAX(CASE
			WHEN mdet.CptCod =  @cCptCod 
				THEN mdet.MdetFac
			END)		as [CSxcFacBrt]
	FROM
		[IMP_Movimiento] as mov
	INNER JOIN
		[IMP_MovimientoDetalle] as mdet
		ON mdet.[ImpCod] = mov.[ImpCod]
		and mdet.[MovCod] = mov.[MovCod]
	WHERE
		mov.[ImpCod] = @ImpCod
		and mdet.[PeriodCod] = @PeriodCod
		and (mdet.[CptCod] = @aCptCod OR mdet.[CptCod] = @bCptCod OR mdet.[CptCod] = @cCptCod)
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
		and tar.TfaCptCod	= tt.ACptCod
	LEFT JOIN
		IMP_TarifaDetalle as tdet
		ON tar.[ImpCod]		= tdet.[ImpCod]
		and tar.[VgfCod]	= tdet.[VgfCod]
		and tar.[TfaCptCod] = tdet.[TfaCptCod]
		and tdet.[TfaItem]	= tt.[TfaItem]
	LEFT JOIN
		IMP_Concepto as cpt
		on tt.ImpCod  = cpt.ImpCod
		and tt.ACptCod = cpt.CptCod
	LEFT JOIN
		IMP_Tarifa as Btar
		on Btar.ImpCod		= cnt.ImpCod
		and Btar.VgfCod		= @VgfCod
		and Btar.TfaCptCod	= tt.BCptCod
	LEFT JOIN
		IMP_TarifaDetalle as Btdet
		ON Btar.[ImpCod]		= Btdet.[ImpCod]
		and Btar.[VgfCod]		= Btdet.[VgfCod]
		and Btar.[TfaCptCod]	= Btdet.[TfaCptCod]
		and Btdet.[TfaItem]		= tt.[TfaItem]
	LEFT JOIN
		IMP_Concepto as Bcpt
		on  tt.ImpCod  = Bcpt.ImpCod
		and tt.BCptCod = Bcpt.CptCod
	LEFT JOIN
		IMP_Tarifa as Ctar
		on Ctar.ImpCod		= cnt.ImpCod
		and Ctar.VgfCod		= @VgfCod
		and Ctar.TfaCptCod	= tt.CCptCod
	LEFT JOIN
		IMP_TarifaDetalle as Ctdet
		ON Ctar.[ImpCod]		= Ctdet.[ImpCod]
		and Ctar.[VgfCod]		= Ctdet.[VgfCod]
		and Ctar.[TfaCptCod]	= Ctdet.[TfaCptCod]
		and Ctdet.[TfaItem]		= tt.[TfaItem]
	LEFT JOIN
		IMP_Concepto as Ccpt
		on  tt.ImpCod	= Ccpt.ImpCod
		and tt.CCptCod	= Ccpt.CptCod
Where 
	cnt.ImpCod = @ImpCod
GROUP BY
	cnt.CntCod,
	cnt.CntNom
