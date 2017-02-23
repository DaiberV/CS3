-- Las que faltan
SELECT
	*
FROM
(
select 
    t.name					as [Table]
    ,fkk.name				as [ID]
    
from 
    [SIIAFE_Inicializado].sys.foreign_key_columns as fk
inner join 
    [SIIAFE_Inicializado].sys.tables as t on fk.parent_object_id = t.object_id
inner join 
    [SIIAFE_Inicializado].sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
inner join
	[SIIAFE_Inicializado].sys.objects as fkk
	ON fkk.object_id = fk.constraint_object_id
EXCEPT
select 
    t.name					as [Table]
    ,fkk.name				as [ID]
    
from 
    [SIIAFE_SABANA_UNIDO].sys.foreign_key_columns as fk
inner join 
    [SIIAFE_SABANA_UNIDO].sys.tables as t on fk.parent_object_id = t.object_id
inner join 
    [SIIAFE_SABANA_UNIDO].sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
inner join
	[SIIAFE_SABANA_UNIDO].sys.objects as fkk
	ON fkk.object_id = fk.constraint_object_id	
) as tt
ORDER BY
	[Table]
	
-- Las que sobran
SELECT
	*
FROM
(
select 
    t.name					as [Table]
    ,fkk.name				as [ID]
    
from 
    [SIIAFE_SABANA_UNIDO].sys.foreign_key_columns as fk
inner join 
    [SIIAFE_SABANA_UNIDO].sys.tables as t on fk.parent_object_id = t.object_id
inner join 
    [SIIAFE_SABANA_UNIDO].sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
inner join
	[SIIAFE_SABANA_UNIDO].sys.objects as fkk
	ON fkk.object_id = fk.constraint_object_id	
EXCEPT
select 
    t.name					as [Table]
    ,fkk.name				as [ID]
    
from 
    [SIIAFE_Inicializado].sys.foreign_key_columns as fk
inner join 
    [SIIAFE_Inicializado].sys.tables as t on fk.parent_object_id = t.object_id
inner join 
    [SIIAFE_Inicializado].sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
inner join
	[SIIAFE_Inicializado].sys.objects as fkk
	ON fkk.object_id = fk.constraint_object_id
) as tt
ORDER BY
	[Table]