
/*
	Exchange Rates Update (using BCCR web service)
	Fetching a web service to use the dollar purchase
	and sell value in a SQL Job to calculate amounts
	in dollars in sells and purchases

	@since 20/12/2020
*/

USE DWH_BD2
GO

/* Exchange Rates (CRC, Banco Central de Costa Rica) */ 
-- Dollar Purchase
DECLARE @DollarPurchaseIndicatorId INT = 317
GO
-- Dollar Sell
DECLARE @DollarSellIndicatorId INT = 318
GO

-- utils for HTTP requests settings...
CREATE PROCEDURE showCurrentOleAutomationProceduresSettings AS
	EXEC sp_configure 'Ole Automation Procedures'
GO

CREATE PROCEDURE setUpOleAutomatioProcedures 
AS
	EXEC sp_configure 'show advanced options', 1;
	RECONFIGURE;
	EXEC sp_configure 'Ole Automation Procedures', 1;
	RECONFIGURE;
GO

-- main procedure
CREATE PROCEDURE getExchangeRateFromBCCR 
	@IdIndicator INT,
	@LastUpdateDate DATE OUT, -- from web service (BCCR)
	@IndicatorValue DECIMAL(12, 4) OUT -- from web service (BCCR)
AS
BEGIN TRY
        DECLARE @postData VARCHAR(500) = CONCAT(
			'Indicador=',			CAST(@IdIndicator AS NVARCHAR(10)),
			'&FechaInicio=',		FORMAT(getdate(), 'dd/MM/yyyy'),
			'&FechaFinal=',			FORMAT(getdate(), 'dd/MM/yyyy'),
			'&Nombre=',				'<registered_name>',
			'&SubNiveles=',			'Si',
			'&CorreoElectronico=',  '<our_email>',
			'&Token=',				'<bccr_token>'
		);

		DECLARE @url AS NVARCHAR(300) = 
			CONCAT(
				'https://gee.bccr.fi.cr/Indicadores/Suscripciones/WS/wsindicadoreseconomicos.asmx/ObtenerIndicadoresEconomicos',
				'?',@postData
			);

		DECLARE @Object AS INT;
		DECLARE @ResponseText AS VARCHAR(8000);

		EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
		EXEC sp_OAMethod @Object, 'open', NULL, 'get', @url, 'false'
		EXEC sp_OAMethod @Object, 'send'
		EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

		SELECT CAST(@ResponseText as XML)
		EXEC sp_OADestroy @Object

    END TRY
    BEGIN CATCH
        SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;  
    END CATCH
GO

-- testing....
DECLARE @LastUpdateAt DATE;
DECLARE @IndicatorValue DECIMAL(12, 4);
DECLARE @IndicatorId INT = 317; 

EXEC getExchangeRateFromBCCR @IndicatorId, @LastUpdateAt, @IndicatorValue;
