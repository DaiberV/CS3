
CREATE FUNCTION [dbo].[FX_Intereses] (@Saldo MONEY, @FecUltInt DATETIME,@FecLiqInt DATETIME) 
    RETURNS MONEY
AS
BEGIN
    DECLARE @Capital NUMERIC(17,4)
	DECLARE @Interes NUMERIC(17,4)
	DECLARE @Tasa NUMERIC(17,8)
	DECLARE @Tiempo NUMERIC(17,4)
	DECLARE @TimFecFin DATETIME
	DECLARE @TimFecIni DATETIME
	DECLARE @TimVlrLiq NUMERIC(17,4)
	DECLARE @atimfecini DATETIME
	DECLARE @atimfecfin DATETIME
	DECLARE @atimtasaanual NUMERIC(17,4)
	DECLARE @atimtipo BIT
	DECLARE @vSwitch CHAR(1)
	DECLARE @vExpo NUMERIC(17,4)
	DECLARE tim_cursor CURSOR FOR SELECT TimFecIni, TimFecFin, TimTasaAno, TimCompu FROM FAC_TasaInteres WHERE TimFecFin >= @FecUltInt ORDER BY TimFecIni ASC
	
	SET @TimVlrLiq=0
	-- si la fecha de inicio de mora es mayor a la de liquidacion los intereses son 0
		If @FecUltInt >= @FecLiqInt
			BEGIN
				RETURN @TimVlrLiq
			END

	OPEN tim_cursor
	
	FETCH NEXT FROM tim_cursor
	INTO @atimfecini, @atimfecfin, @atimtasaanual, @atimtipo
	
	SET @Capital = @Saldo
	SET @TimFecIni = @FecUltInt + 1
	SET @vSwitch = 'S'

	WHILE @@FETCH_STATUS = 0 and @vSwitch = 'S' 
	BEGIN 
		SET @TimFecFin = @atimfecfin
		IF @TimFecFin > @FecLiqInt
			BEGIN 
			SET @TimFecFin = @FecLiqInt
			END

		SET @Tiempo = ( DATEDIFF(DAY,@TimFecIni,@TimFecFin) + 1 )


		IF @atimtipo = 0
			BEGIN
			SET @Tasa = @atimtasaanual/36500
            SET @Interes   = round(@Capital * @Tasa * @Tiempo,0)
			END
        ELSE
			BEGIN
			SET @vExpo = @Tiempo/365
            SET @Interes   = @Capital * (POWER(1 + @atimtasaanual/100,@vExpo)-1 ) 
            SET @Capital   = @Capital + round(@Interes,0) 
			END

		SET @TimVlrLiq = @TimVlrLiq + @Interes 
		
		SET @TimFecIni = @TimFecFin + 1
   
		If @TimFecFin = @FecLiqInt
			BEGIN
		    SET @vSwitch = 'N'
			END
		
		FETCH NEXT FROM tim_cursor
		INTO @atimfecini, @atimfecfin, @atimtasaanual, @atimtipo
	END

	CLOSE tim_cursor
	DEALLOCATE tim_cursor

    RETURN round(@TimVlrLiq,0)
END
