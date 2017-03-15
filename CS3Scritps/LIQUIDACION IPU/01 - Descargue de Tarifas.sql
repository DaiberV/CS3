DECLARE @ImpCod CHAR(10) = 'IPU';
DECLARE @VgfCod CHAR(10) = '2017';
DECLARE @TfaCptCod CHAR(10) = 'P01';
SELECT 
	   tdet.[ImpCod]
      ,tdet.[VgfCod]
      ,cpto.[CptNom]
      ,[TfaBseIni]
      ,[TfaBseFin]
      ,[TfaVlrFij]
      ,[TfaVlrPrc]
      ,[TfaVlrTip]
      ,[TfaAplLim]
      ,[TfaOrd]
      ,ISNULL([TfaNoLiq],0)		AS [TfaNoLiq]
      ,[TfaTrrFin]
      ,[TfaTrrIni]
      ,ISNULL([TfaCrdCaus],0)	AS [TfaCrdCaus]
      ,ISNULL([TfaCrdPrc],0)	AS [TfaCrdPrc]
  FROM [IMP_TarifaDetalle] as tdet
	INNER JOIN 
		IMP_Tarifa AS TAR
		  ON TAR.ImpCod		= tdet.ImpCod
		  AND TAR.VgfCod	= tdet.VgfCod
		  AND TAR.TfaCptCod = tdet.TfaCptCod
	INNER JOIN
		IMP_Concepto AS cpto
		ON cpto.ImpCod = tar.ImpCod
		and cpto.CptCod = tar.TfaCptCod
  WHERE 
		tdet.ImpCod			= @ImpCod
		and tdet.VgfCod		= @VgfCod
		and tdet.TfaCptCod	= @TfaCptCod