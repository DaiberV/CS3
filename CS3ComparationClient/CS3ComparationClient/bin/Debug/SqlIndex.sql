USE <<ORIGEN>>;
SELECT * FROM (
SELECT 
I.name   [CreateIndexScript]  
FROM 
sys.indexes I    
JOIN 
sys.tables T 
ON T.Object_id = I.Object_id     
JOIN 
sys.sysindexes SI 
ON I.Object_id = SI.id AND I.index_id = SI.indid    
JOIN 
(
SELECT 
* 
FROM 
(   
SELECT 
IC2.object_id 
, IC2.index_id 
, STUFF(
(SELECT 
' , ' + C.name + CASE WHEN MAX(CONVERT(INT,IC1.is_descending_key)) = 1 THEN ' DESC ' ELSE ' ASC ' END 
FROM 
sys.index_columns IC1   
JOIN 
Sys.columns C    
ON C.object_id = IC1.object_id    
AND C.column_id = IC1.column_id    
AND IC1.is_included_column = 0   
WHERE 
IC1.object_id = IC2.object_id    
AND IC1.index_id = IC2.index_id    
GROUP BY 
IC1.object_id
,C.name,index_id   
ORDER BY 
MAX(IC1.key_ordinal)   
FOR 
XML PATH('')), 1, 2, ''
) KeyColumns    
FROM 
sys.index_columns IC2    
GROUP BY 
IC2.object_id 
,IC2.index_id
) tmp3 
)tmp4    
ON I.object_id = tmp4.object_id 
AND I.Index_id = tmp4.index_id   
JOIN 
sys.stats ST 
ON ST.object_id = I.object_id 
AND ST.stats_id = I.index_id    
JOIN 
sys.data_spaces DS 
ON I.data_space_id=DS.data_space_id    
JOIN sys.filegroups FG 
ON I.data_space_id=FG.data_space_id    
LEFT JOIN 
(
SELECT 
* 
FROM 
(    
SELECT 
IC2.object_id 
, IC2.index_id 
, STUFF(
(
SELECT 
' , ' + C.name  
FROM 
sys.index_columns IC1    
JOIN 
Sys.columns C     
ON C.object_id = IC1.object_id     
AND C.column_id = IC1.column_id     
AND IC1.is_included_column = 1    
WHERE 
IC1.object_id = IC2.object_id     
AND IC1.index_id = IC2.index_id     
GROUP BY 
IC1.object_id
,C.name
,index_id    
FOR XML PATH('')
), 1, 2, '') IncludedColumns     
FROM 
sys.index_columns IC2   
GROUP BY 
IC2.object_id ,IC2.index_id
) tmp1    
WHERE 
IncludedColumns IS NOT NULL 
) tmp2     
ON tmp2.object_id = I.object_id 
AND tmp2.index_id = I.index_id    
INNER JOIN
(
SELECT 
t.name as TableName
,ind.name as IndexName
FROM 
<<ORIGEN>>.sys.indexes ind 
INNER JOIN 
<<ORIGEN>>.sys.index_columns ic 
ON  ind.object_id = ic.object_id 
and ind.index_id = ic.index_id 
INNER JOIN 
<<ORIGEN>>.sys.columns col 
ON ic.object_id = col.object_id 
and ic.column_id = col.column_id 
INNER JOIN 
<<ORIGEN>>.sys.tables t 
ON ind.object_id = t.object_id 
WHERE 
ind.is_primary_key = 0 
AND t.is_ms_shipped = 0
) as tt
ON I.Object_id = object_id(tt.[TableName]) 
AND I.name = tt.[IndexName] 
WHERE 
I.is_primary_key = 0 
AND I.is_unique_constraint = 0  
)
TEMP
GROUP BY
TEMP.CreateIndexScript