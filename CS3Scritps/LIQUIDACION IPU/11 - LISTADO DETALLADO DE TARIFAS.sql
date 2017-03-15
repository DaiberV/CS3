DECLARE @ImpCod char(10) = 'IPU';
DECLARE @VgfCod numeric(5) = 2017;
DECLARE @TfaCptoCod char(5) = 'P02';
DECLARE @Destinos varchar(1000);

SELECT 
		 tdet.TfaOrd					AS [ORDEN]
		,tdet.[TfaBseIni]				AS [BASE INICIAL]
		,tdet.[TfaBseFin]				AS [BASE FINAL]
		,tdet.[TfaTrrIni]				AS [AREA INICIAL]
		,tdet.[TfaTrrFin]				AS [AREA FINAL]
		,tdet.[TfaVlrFij]				AS [VALOR FIJO]
		,tdet.[TfaVlrPrc]				AS [VALOR PORCENTUAL]
		,(CASE
				WHEN tdet.TfaVlrTip = 0
					THEN 'FIJA'
				WHEN tdet.TfaVlrTip = 1
					THEN 'UND'
				WHEN tdet.TfaVlrTip = 100
					THEN '%'
				WHEN tdet.TfaVlrTip = 1000
					THEN 'MIL'
		  Else
			'-'
		  END)							AS [TIPO]  
		,ISNULL(caus.CausNom,'-')		AS [CAUSAL]
		,ISNULL(cab1.CprNom,'-')		AS [CLASE]
		,ISNULL(cab2.DstNom,'-')		AS [DESTINO]
		,ISNULL(cab3.EstNom,'-')		AS [ESTRATO]
		,ISNULL(cab4.TprNom,'-')		AS [TIPO]
		,ISNULL(cab5.UsoNom,'-')		AS [USO]
FROM [IMP_TarifaDetalle] as tdet
	INNER JOIN 
		IMP_Tarifa			AS TAR
		  ON TAR.ImpCod		= tdet.ImpCod
		  AND TAR.VgfCod	= tdet.VgfCod
		  AND TAR.TfaCptCod = tdet.TfaCptCod
	INNER JOIN
		IMP_Concepto		AS cpto
		ON cpto.ImpCod		= tar.ImpCod
		and cpto.CptCod		= tar.TfaCptCod
	INNER JOIN 
		NOT_Causal			AS caus
		ON caus.ImpCod		= tdet.ImpCod
		and caus.CausCod	= tdet.TfaCrdCaus
	LEFT JOIN
		PRD_TarifaClase		AS cls
		ON cls.ImpCod		= tdet.ImpCod
		and cls.VgfCod		= tdet.VgfCod
		and cls.TfaCptCod	= tdet.TfaCptCod
		and cls.TfaItem		= tdet.TfaItem
	LEFT JOIN
		PRD_Clase			AS cab1
		ON cab1.CprCod		= cls.CprCod
	LEFT JOIN 
		PRD_TarifaDestino	AS dst
		ON dst.ImpCod		= tdet.ImpCod
		and dst.VgfCod		= tdet.VgfCod 
		and dst.TfaCptCod	= tdet.TfaCptCod
		and dst.TfaItem		= tdet.TfaItem
	LEFT JOIN
		PRD_Destino			AS cab2
		ON cab2.DstCod		= dst.DstCod
	LEFT JOIN 
		PRD_TarifaEstrato	AS est
		ON est.ImpCod		= tdet.ImpCod
		and est.VgfCod		= tdet.VgfCod
		and est.TfaCptCod	= tdet.TfaCptCod
		and est.TfaItem		= tdet.TfaItem
	LEFT JOIN
		PRD_Estrato			AS cab3
		ON cab3.EstCod		= est.EstCod
	LEFT JOIN
		PRD_TarifaTipo		AS tip
		ON tip.ImpCod		= tdet.ImpCod
		and tip.VgfCod		= tdet.VgfCod
		and tip.TfaCptCod	= tdet.TfaCptCod
		and tip.TfaItem		= tdet.TfaItem
	LEFT JOIN
		PRD_Tipo			AS cab4
		ON cab4.TprCod		= tip.TprCod
	LEFT JOIN
		PRD_TarifaUso		AS uso
		ON uso.ImpCod		= tdet.ImpCod
		and uso.VgfCod		= tdet.VgfCod
		and uso.TfaCptCod	= tdet.TfaCptCod
		and uso.TfaItem		= tdet.TfaItem
	LEFT JOIN 
		PRD_Uso				AS cab5
		ON cab5.UsoCod		= cab5.UsoCod
  WHERE 
		tdet.ImpCod			= @ImpCod
		and tdet.VgfCod		= @VgfCod
		and tdet.TfaCptCod	= @TfaCptoCod
