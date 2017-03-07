CREATE TABLE #x 
(
  create_script NVARCHAR(MAX)
);
  
insert into #x 
SELECT 'ALTER TABLE ' 
+ QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
+ ' ADD CONSTRAINT ' + QUOTENAME(fk.name) 
+ ' FOREIGN KEY (' + STUFF((SELECT ',' + QUOTENAME(c.name)
FROM <<ORIGEN>>.sys.columns AS c 
INNER JOIN <<ORIGEN>>.sys.foreign_key_columns AS fkc 
ON fkc.parent_column_id = c.column_id
AND fkc.parent_object_id = c.[object_id]
WHERE fkc.constraint_object_id = fk.[object_id]
ORDER BY fkc.constraint_column_id 
FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'')
+ ') REFERENCES ' + QUOTENAME(rs.name) + '.' + QUOTENAME(rt.name)
+ '(' + STUFF((SELECT ',' + QUOTENAME(c.name)
FROM <<ORIGEN>>.sys.columns AS c 
INNER JOIN <<ORIGEN>>.sys.foreign_key_columns AS fkc 
ON fkc.referenced_column_id = c.column_id
AND fkc.referenced_object_id = c.[object_id]
WHERE fkc.constraint_object_id = fk.[object_id]
ORDER BY fkc.constraint_column_id 
FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'') + ');'
FROM <<ORIGEN>>.sys.foreign_keys AS fk
INNER JOIN <<ORIGEN>>.sys.tables AS rt 
  ON fk.referenced_object_id = rt.[object_id]
INNER JOIN <<ORIGEN>>.sys.schemas AS rs 
  ON rt.[schema_id] = rs.[schema_id]
INNER JOIN <<ORIGEN>>.sys.tables AS ct 
  ON fk.parent_object_id = ct.[object_id]
INNER JOIN <<ORIGEN>>.sys.schemas AS cs 
  ON ct.[schema_id] = cs.[schema_id]
WHERE rt.is_ms_shipped = 0 AND ct.is_ms_shipped = 0
and fk.name = '<<OBJETO>>';

select
	*
from
	#x
drop table #x