DECLARE @FECHA date = '2016-11-28';
DECLARE @DIA VARCHAR(10) = 'ClieEjeLunes';


WITH [GG] AS
(
SELECT
	client.ClieCod			as [ClieCod]
	,client.ProdCod			as [ProdCod]
	,client.ClieNom			as [ClieNom]
	,back.BckNom			as [BckNom]
	,back.BckFec			as [BckFec]
	,back.BckMsg			as [BckMsg]
	,back.BckTam			as [BckTam]
	,back.BckEst			as [BckEst]
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
)
,[HH] AS
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
WHERE
	cli.ClieEjeLunes = 1	
GROUP BY
	cli.ClieCod
	,prd.ProdCod

EXCEPT

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
,[JJ] AS
(
SELECT 
	*
FROM 
	GG

UNION ALL

SELECT
		 HH.[ClieCod]
		,HH.ProdCod
		,HH.[ClieNom]
		,'-'							AS [BckNom]
		,''								AS [BckFec]
		,'Backup no Realizado'			AS [BckMsg]
		,00								AS [BckTam]
		,0								AS [BckEst]
FROM
	HH
)
SELECT 
	*
FROM
	JJ
ORDER BY 
JJ.ClieCod