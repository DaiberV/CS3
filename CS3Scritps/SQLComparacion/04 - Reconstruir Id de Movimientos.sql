UPDATE
	[IMP_Movimiento]
SET	[MovId] =
	(Year([MovFec]) % 100)*1000000000000
	+ (
	CASE
		WHEN [MovTip] = 'CAUSACION' THEN 0
		WHEN [MovTip] = 'NOTA_CREDITO' THEN 8
		WHEN [MovTip] = 'NOTA_DEBITO' THEN 9
		WHEN [MovTip] = 'PAGO_FACTURA' THEN 4
		ELSE 99
	END	
	)*10000000000
	+ imp.[ImpCnsInd]*100000000
	+ mov.[MovCod]
FROM 
	[IMP_Movimiento] as mov
INNER JOIN
	[IMP_Impuesto] as imp
	On mov.[ImpCod] = imp.[ImpCod]
WHERE
	[MovId] = 0 or [MovId] is null