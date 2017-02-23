/* 862132269
SELECT *,timediff(regHoraSalida,regHoraEntrada),(time_to_sec(timediff(regHoraSalida,regHoraEntrada))/3600)
FROM registros
WHERE (time_to_sec(timediff(regHoraSalida,regHoraEntrada))/3600) > 0 and
	(time_to_sec(timediff(regHoraSalida,regHoraEntrada))/3600) < 0.15;
*/

/* Reporte Consolidado */
SELECT ttt.Cedula,ttt.Nombre,Sum(ttt.HorasTrabajadas) as 'HorasTrabajadas'
FROM
(
	/* Reporte Diario */
	SELECT tt.Cedula,tt.Nombre,tt.Fecha,Sum(tt.HorasTrabajadas) as 'HorasTrabajadas'
	FROM
	(
		/* Reporte Detallado */
		SELECT e.empCodigo as 'Cedula',e.empNombre as 'Nombre',t.Fecha,t.Entrada,t.Salida,t.Nota,timediff(t.salida,t.entrada) as 'Diferencia',(time_to_sec(timediff(t.salida,t.entrada))/3600) as 'HorasTrabajadas'
		FROM
		(
				SELECT 	 r.empCodigo as 'EmpCodigo'
						,r.regFecha as 'Fecha'
						,r.regItem as 'Item'
						,r.regHoraEntrada as 'Entrada'
						,r.regHoraSalida as 'Salida'
						,'registro ordinario' as 'Nota'
				FROM prueba.registros as r
				WHERE r.regfecha >= '2016-10-01' and r.regFecha <= '2016-10-31'
			Union
				SELECT   n.empCodigo as 'EmpCodigo'
						,n.novFecha as 'Fecha'
						,0 as 'Item'
						,n.novHoraEntrada as 'Entrada'
						,n.novHoraSalida as 'Salida'
						,n.novDescripcion as 'Nota'
				FROM prueba.novedad as n
				WHERE n.novfecha >= '2016-10-01' and n.novFecha <= '2016-10-31' and n.novclaCodigo=1
		) as t
			INNER JOIN empleado as e
				ON t.empCodigo=e.empCodigo
		ORDER BY t.EmpCodigo,t.Fecha,t.Entrada
	) as tt
	GROUP BY tt.Cedula,tt.Nombre,tt.Fecha
	ORDER BY tt.Cedula,tt.Nombre,tt.Fecha
) as ttt
GROUP BY ttt.Cedula,ttt.Nombre
ORDER BY ttt.Cedula,ttt.Nombre