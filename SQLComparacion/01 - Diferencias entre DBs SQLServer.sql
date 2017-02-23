-- Todas las tablas que estan en la BD1 pero no en la BD2
SELECT ini.name
FROM <<ORIGEN>>.sys.Tables as ini
LEFT JOIN <<DESTINO>>.sys.Tables as fin On ini.name=fin.name
WHERE  fin.name is null;

-- Lo Contrario de lo anterior
SELECT fin.name
FROM <<DESTINO>>.sys.Tables as fin
LEFT JOIN <<ORIGEN>>.sys.Tables as ini On ini.name=fin.name
WHERE  ini.name is null;

-- Todos los atributos que tenga la DB1 pero no la DB2
SELECT ini.name, icol.name, type_name(icol.system_type_id), icol.max_length
FROM <<ORIGEN>>.sys.Tables as ini
INNER JOIN <<ORIGEN>>.sys.Columns as icol On ini.object_id=icol.object_id
LEFT JOIN <<DESTINO>>.sys.Tables as Fin On ini.name=fin.name
LEFT JOIN <<DESTINO>>.sys.Columns as fcol On fin.object_id=fcol.object_id and icol.name=fcol.name
WHERE fcol.name is null;

-- Lo Contrario de lo anterior
SELECT fin.name, fcol.name, type_name(fcol.system_type_id), fcol.max_length
FROM <<DESTINO>>.sys.Tables as Fin 
INNER JOIN <<DESTINO>>.sys.Columns as fcol On fin.object_id=fcol.object_id
LEFT JOIN <<ORIGEN>>.sys.Tables as ini On ini.name=fin.name
LEFT JOIN <<ORIGEN>>.sys.Columns as icol On ini.object_id=icol.object_id and icol.name=fcol.name
WHERE icol.name is null;

-- Todo atributo que tenga tipo o longitud distinto entre las dos bases de datos
WITH TT AS(SELECT ini.name, icol.name AS fname, type_name(icol.system_type_id) AS [TIPO ORIGEN],TYPE_NAME(fcol.system_type_id) AS [TIPO DESTINO]
	,CASE
		WHEN TYPE_NAME(icol.system_type_id) = 'decimal'
			THEN CONVERT(DECIMAL(4,1),(CONVERT(decimal,(RTRIM(convert(char,icol.precision)) + '' + RTRIM(convert(char,icol.scale))))/10))
		ELSE
			icol.max_length
		END	as [prueba]		
	,CASE
		WHEN TYPE_NAME(fcol.system_type_id) = 'decimal'
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
	TT.prueba <> TT.prueba2;

-- ============================================================================================================= 
-- Query Que Crea Las Tablas Que Existan En EL <<ORIGEN>> Pero No El <<DESTINO>>
SELECT 'SELECT * INTO '+ini.name+' FROM <<ORIGEN>>.dbo.'+ini.name+';'
FROM <<ORIGEN>>.sys.Tables as ini
LEFT JOIN <<DESTINO>>.sys.Tables as fin On ini.name=fin.name
WHERE  fin.name is null;

-- Agrega Atributos Faltantes
SELECT 'ALTER TABLE '+ini.name+' ADD '+icol.name+' '+type_name(icol.system_type_id)+
	(CASE 
		WHEN type_name(icol.system_type_id) = 'decimal' and icol.max_length = 9
			THEN '(15,2)'
		WHEN type_name(icol.system_type_id) in ('datetime','bit','int','smallint','money','smallmoney')
			THEN ''
		WHEN type_name(icol.system_type_id) in ('varchar','varbinary')
			THEN '(max)'
		ELSE
			'('+CONVERT(VARCHAR(4),icol.max_length)+')'
	END)+' null;'
FROM <<ORIGEN>>.sys.Tables as ini
INNER JOIN <<ORIGEN>>.sys.Columns as icol On ini.object_id=icol.object_id
LEFT JOIN <<DESTINO>>.sys.Tables as Fin On ini.name=fin.name
LEFT JOIN <<DESTINO>>.sys.Columns as fcol On fin.object_id=fcol.object_id and icol.name=fcol.name
WHERE fcol.name is null;

-- Modifica Atributos
SELECT 'ALTER TABLE '+ini.name+' ALTER COLUMN '+icol.name+' '+type_name(icol.system_type_id)+
	(CASE 
		WHEN type_name(icol.system_type_id) = 'decimal' and icol.max_length = 9
			THEN '(15,2)'
		WHEN type_name(icol.system_type_id) in ('datetime','bit','int','smallint','money','smallmoney')
			THEN ''
		WHEN type_name(icol.system_type_id) in ('varchar','varbinary')
			THEN '(max)'
		ELSE
			'('+CONVERT(VARCHAR(4),icol.max_length)+')'
	END)+' not null;'
FROM <<ORIGEN>>.sys.Tables as ini
INNER JOIN <<ORIGEN>>.sys.Columns as icol On ini.object_id=icol.object_id
INNER JOIN <<DESTINO>>.sys.Tables as Fin On ini.name=fin.name
INNER JOIN <<DESTINO>>.sys.Columns as fcol On fin.object_id=fcol.object_id and icol.name=fcol.name
WHERE icol.system_type_id<>fcol.system_type_id or icol.max_length<>fcol.max_length;