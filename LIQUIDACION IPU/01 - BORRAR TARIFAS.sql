DELETE
	[PRD_TarifaEstrato]
WHERE 
	[VgfCod] IN (2017,2018);


DELETE
	[PRD_TarifaUso]
WHERE 
	[VgfCod] IN (2017,2018);
	
DELETE
	[PRD_TarifaClase]
WHERE 
	[VgfCod] IN (2017,2018);

DELETE
	[PRD_TarifaTipo]
WHERE 
	[VgfCod] IN (2017,2018);
	
DELETE
	[PRD_TarifaDestino]
WHERE 
	[VgfCod] IN (2017,2018);

DELETE
	[IMP_TarifaDetalle]
WHERE 
	[VgfCod] IN (2017,2018);
	
DELETE
	[IMP_Tarifa]
WHERE 
	[VgfCod] IN (2017,2018);