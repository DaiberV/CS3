WITH TT AS(SELECT ini.name, icol.name AS fname, type_name(icol.system_type_id) AS [TIPO ORIGEN]
,CASE
WHEN TYPE_NAME(icol.system_type_id) = 'decimal'
THEN CONVERT(DECIMAL(4,1),(CONVERT(decimal,(RTRIM(convert(char,icol.precision)) + '' + RTRIM(convert(char,icol.scale))))/10))
ELSE
icol.max_length END as [prueba] ,CASE
WHEN icol.is_nullable = 1
THEN 'NULL'
ELSE
'NOT NULL'
END AS [ISNULL]
FROM <<ORIGEN>>.sys.Tables as ini
INNER JOIN <<ORIGEN>>.sys.Columns as icol On ini.object_id=icol.object_id
)
,GG AS(
SELECT TT.name AS [BASE ORIGEN]
,TT.fname AS [BASE DESTINO]
,TT.[TIPO ORIGEN] AS [TIPO ORIGEN]
,TT.prueba AS [TAMAÑO ORIGEN]
,TT.ISNULL AS [VACIO ORIGEN]
FROM
TT
WHERE 
TT.fname = '<<OBJETO>>'
AND TT.name = '<<TABLA>>'
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