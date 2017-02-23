-- Todas las tablas que estan en la BD1 pero no en la BD2
SELECT ini.name
FROM [SIIAFE_Inicializado].sys.Tables as ini
LEFT JOIN [SIIAFE_SABANA_UNIDO].sys.Tables as fin On ini.name=fin.name
WHERE  fin.name is null;

-- Lo Contrario de lo anterior
SELECT fin.name
FROM [SIIAFE_SABANA_UNIDO].sys.Tables as fin
LEFT JOIN [SIIAFE_Inicializado].sys.Tables as ini On ini.name=fin.name
WHERE  ini.name is null;

-- Todos los atributos que tenga la DB1 pero no la DB2
SELECT 'Alter Table '+ini.name+' Add '+icol.name+' '+type_name(icol.system_type_id)+'('+RTrim(Cast(icol.max_length As CHAR(20)))+') NULL'
FROM [SIIAFE_Inicializado].sys.Tables as ini
INNER JOIN [SIIAFE_Inicializado].sys.Columns as icol On ini.object_id=icol.object_id
LEFT JOIN [SIIAFE_SABANA_UNIDO].sys.Tables as Fin On ini.name=fin.name
LEFT JOIN [SIIAFE_SABANA_UNIDO].sys.Columns as fcol On fin.object_id=fcol.object_id and icol.name=fcol.name
WHERE fcol.name is null;

-- Lo Contrario de lo anterior
SELECT fin.name, fcol.name, type_name(fcol.system_type_id), fcol.max_length
FROM [SIIAFE_SABANA_UNIDO].sys.Tables as Fin 
INNER JOIN [SIIAFE_SABANA_UNIDO].sys.Columns as fcol On fin.object_id=fcol.object_id
LEFT JOIN [SIIAFE_Inicializado].sys.Tables as ini On ini.name=fin.name
LEFT JOIN [SIIAFE_Inicializado].sys.Columns as icol On ini.object_id=icol.object_id and icol.name=fcol.name
WHERE icol.name is null;

-- Todo atributo que tenga tipo o longitud distinto entre las dos bases de datos
SELECT ini.name, icol.name, type_name(icol.system_type_id), icol.max_length, type_name(fcol.system_type_id), fcol.max_length
FROM [SIIAFE_Inicializado].sys.Tables as ini
INNER JOIN [SIIAFE_Inicializado].sys.Columns as icol On ini.object_id=icol.object_id
INNER JOIN [SIIAFE_SABANA_UNIDO].sys.Tables as Fin On ini.name=fin.name
INNER JOIN [SIIAFE_SABANA_UNIDO].sys.Columns as fcol On fin.object_id=fcol.object_id and icol.name=fcol.name
WHERE icol.system_type_id<>fcol.system_type_id or icol.max_length<>fcol.max_length;


-- ============================================================================================================= 
-- Query Que Crea Las Tablas Que Existan En EL [SIIAFE_Inicializado] Pero No El [SIIAFE_SABANA_UNIDO]
SELECT 'SELECT * INTO '+ini.name+' FROM [SIIAFE_Inicializado].dbo.'+ini.name+';'
FROM [SIIAFE_Inicializado].sys.Tables as ini
LEFT JOIN [SIIAFE_SABANA_UNIDO].sys.Tables as fin On ini.name=fin.name
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
FROM [SIIAFE_Inicializado].sys.Tables as ini
INNER JOIN [SIIAFE_Inicializado].sys.Columns as icol On ini.object_id=icol.object_id
LEFT JOIN [SIIAFE_SABANA_UNIDO].sys.Tables as Fin On ini.name=fin.name
LEFT JOIN [SIIAFE_SABANA_UNIDO].sys.Columns as fcol On fin.object_id=fcol.object_id and icol.name=fcol.name
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
FROM [SIIAFE_Inicializado].sys.Tables as ini
INNER JOIN [SIIAFE_Inicializado].sys.Columns as icol On ini.object_id=icol.object_id
INNER JOIN [SIIAFE_SABANA_UNIDO].sys.Tables as Fin On ini.name=fin.name
INNER JOIN [SIIAFE_SABANA_UNIDO].sys.Columns as fcol On fin.object_id=fcol.object_id and icol.name=fcol.name
WHERE icol.system_type_id<>fcol.system_type_id or icol.max_length<>fcol.max_length;