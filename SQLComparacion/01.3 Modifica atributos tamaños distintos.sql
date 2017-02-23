WITH [TT] AS(SELECT ini.name, icol.name AS fname, type_name(icol.system_type_id) AS [TIPO ORIGEN],TYPE_NAME(fcol.system_type_id) AS [TIPO DESTINO]
	,CASE
		WHEN TYPE_NAME(icol.system_type_id) = 'decimal' and icol.max_length = 9
			THEN CONVERT(DECIMAL(4,1),(CONVERT(decimal,(RTRIM(convert(char,icol.precision)) + '' + RTRIM(convert(char,icol.scale))))/10))
		ELSE
			icol.max_length
		END	as [prueba]		
	,CASE
		WHEN TYPE_NAME(fcol.system_type_id) = 'decimal' and fcol.max_length = 9
			THEN CONVERT(DECIMAL(4,1),(CONVERT(decimal,(RTRIM(convert(char,fcol.precision)) + '' + RTRIM(convert(char,fcol.scale))))/10))
		ELSE
			fcol.max_length
		END	as [prueba2]
	,CASE
		WHEN icol.is_nullable = 1
			THEN 'NULL'
		ELSE
			'NOT NULL'
		END AS [ISNULL]
	,CASE
		WHEN fcol.is_nullable = 1
			THEN 'NULL'
		ELSE
			'NOT NULL'
		END AS [FISNULL]
FROM <<ORIGEN>>.sys.Tables as ini
INNER JOIN <<ORIGEN>>.sys.Columns as icol On ini.object_id=icol.object_id
INNER JOIN <<DESTINO>>.sys.Tables as Fin On ini.name=fin.name
INNER JOIN <<DESTINO>>.sys.Columns as fcol On fin.object_id=fcol.object_id and icol.name=fcol.name
)
, 
[GG] as(
SELECT
	TT.name					AS	[BASE ORIGEN]
	,TT.fname				AS	[BASE DESTINO]
	,TT.[TIPO ORIGEN]		AS	[TIPO ORIGEN]
	,TT.prueba				AS	[TAMAÑO ORIGEN]
	,TT.ISNULL				AS  [VACIO ORIGEN]
	,TT.[TIPO DESTINO]		AS	[TIPO DESTINO]
	,TT.prueba2				AS	[TAMAÑO DESTINO]
	,TT.FISNULL				AS	[VACIO DESTINO]
FROM
	TT
WHERE
	TT.prueba <> TT.prueba2
	
)
SELECT
case
	WHEN gg.[TIPO ORIGEN] <> 'decimal'
		Then 'ALTER TABLE '+GG.[BASE ORIGEN]+' ALTER COLUMN '+GG.[BASE DESTINO]+' '+GG.[TIPO ORIGEN]+' ('+REPLACE(RTRIM(convert(CHAR,(GG.[TAMAÑO ORIGEN]))),'.0','')+') '+GG.[VACIO ORIGEN]  
	ELSE
		'ALTER TABLE '+gg.[BASE ORIGEN]+' ALTER COLUMN '+gg.[BASE DESTINO]+' '+gg.[TIPO ORIGEN]+' ('+REPLACE(RTRIM(convert(char,gg.[TAMAÑO ORIGEN])),'.',',')+') '+gg.[VACIO ORIGEN]
	END
From
	gg;