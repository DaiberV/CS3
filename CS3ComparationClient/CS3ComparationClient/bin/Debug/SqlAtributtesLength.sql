WITH TT AS(SELECT ini.name, icol.name AS fname, type_name(icol.system_type_id) AS [TIPO ORIGEN]
,CASE
WHEN TYPE_NAME(icol.system_type_id) = 'decimal'
THEN CONVERT(DECIMAL(4,1),(CONVERT(decimal,(RTRIM(convert(char,icol.precision)) + '' + RTRIM(convert(char,icol.scale))))/10))
ELSE
icol.max_length END	as [prueba]		
,CASE WHEN icol.is_nullable = 1
THEN 'NULL'
ELSE
'NOT NULL'
END AS [ISNULL]
FROM <<ORIGEN>>.sys.Tables as ini
INNER JOIN <<ORIGEN>>.sys.Columns as icol On ini.object_id=icol.object_id
)
SELECT
(TT.name +'+'+TT.fname +' '+tt.[TIPO ORIGEN] +' '+RTRIM(CONVERT(char(10),tt.PRUEBA)) )
FROM
TT