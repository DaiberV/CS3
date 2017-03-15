-- Las que faltan
SELECT
	*
FROM
(
select 
    t.name					as [Table]
    ,fkk.name				as [ID]
    
from 
    <<ORIGEN>>.sys.foreign_key_columns as fk
inner join 
    <<ORIGEN>>.sys.tables as t on fk.parent_object_id = t.object_id
inner join 
    <<ORIGEN>>.sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
inner join
	<<ORIGEN>>.sys.objects as fkk
	ON fkk.object_id = fk.constraint_object_id
EXCEPT
select 
    t.name					as [Table]
    ,fkk.name				as [ID]
    
from 
    <<DESTINO>>.sys.foreign_key_columns as fk
inner join 
    <<DESTINO>>.sys.tables as t on fk.parent_object_id = t.object_id
inner join 
    <<DESTINO>>.sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
inner join
	<<DESTINO>>.sys.objects as fkk
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
    <<DESTINO>>.sys.foreign_key_columns as fk
inner join 
    <<DESTINO>>.sys.tables as t on fk.parent_object_id = t.object_id
inner join 
    <<DESTINO>>.sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
inner join
	<<DESTINO>>.sys.objects as fkk
	ON fkk.object_id = fk.constraint_object_id	
EXCEPT
select 
    t.name					as [Table]
    ,fkk.name				as [ID]
    
from 
    <<ORIGEN>>.sys.foreign_key_columns as fk
inner join 
    <<ORIGEN>>.sys.tables as t on fk.parent_object_id = t.object_id
inner join 
    <<ORIGEN>>.sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
inner join
	<<ORIGEN>>.sys.objects as fkk
	ON fkk.object_id = fk.constraint_object_id
) as tt
ORDER BY
	[Table]