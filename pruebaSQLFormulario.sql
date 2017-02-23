/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
*
FROM 
	[DCL_Declaracion] as dcl
inner join
	DCL_DeclaracionDetalle as det
	on dcl.ImpCod = det.ImpCod
	and dcl.DclCod = det.DclCod
  Where
  dcl.ImpCod = 'ICAT'
  and det.FAttCod = 'ACTBAS3'
  and dcl.DclCod = 18
  
  
  
  /*  base */
  SELECT
	DET.FLsdOrd
	,DET.FAttCod
	,ATT.FAttTip
	,lst.ImpCod
	,lst.FormCod
FROM
	FRM_Listado	AS lst
INNER JOIN
	FRM_ListadoDet AS det
	ON lst.ImpCod = det.ImpCod
	and lst.FLstCod = det.FLstCod
INNER JOIN
	FRM_FormularioAtributo AS att
	ON lst.ImpCod = att.ImpCod
	and lst.FormCod = att.FormCod
	and det.FAttCod = att.FAttCod
	
	
/* prueba */

SELECT
	*
FROM
	FRM_Listado	AS lst
INNER JOIN
	FRM_ListadoDet AS det
	ON lst.ImpCod = det.ImpCod
	and lst.FLstCod = det.FLstCod
INNER JOIN
	FRM_FormularioAtributo AS att
	ON lst.ImpCod = att.ImpCod
	and lst.FormCod = att.FormCod
	and det.FAttCod = att.FAttCod
ORDER BY
	DET.FLsdOrd
  
  
  