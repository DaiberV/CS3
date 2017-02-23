DECLARE @FECHA date = '2016-11-28'
SELECT 
	   cli.[ClieCod]
	   ,prd.ProdCod
      ,MAX(cli.[ClieNom]) as [ClieNom]
FROM 
	[HQ_Cliente] as cli
	INNER JOIN HQ_ClienteProducto AS clip
	on cli.ClieCod=clip.ClieCod
	INNER JOIN HQ_Producto AS prd
	on clip.ProdCod=prd.ProdCod
WHERE
	cli.ClieEjeLunes =1	
GROUP BY
	cli.ClieCod
	,prd.ProdCod

EXCEPT
(
SELECT
	client.ClieCod
	,client.ProdCod
	,client.ClieNom
FROM
	HQ_Backup as back
	INNER JOIN 

(
SELECT 
	   cli.[ClieCod]
	   ,prd.ProdCod
      ,MAX(cli.[ClieNom]) as [ClieNom]
  FROM 
	[HQ_Cliente] as cli
	INNER JOIN HQ_ClienteProducto AS clip
	on cli.ClieCod=clip.ClieCod
	INNER JOIN HQ_Producto AS prd
	on clip.ProdCod=prd.ProdCod
GROUP BY
	cli.ClieCod
	,prd.ProdCod
) as client
on back.ClieCod = client.ClieCod
and back.ProdCod = client.ProdCod
Where
	back.BckFec = @FECHA
	and back.BckEst = 1
)
ORDER BY
	cli.ClieCod
	