
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
DECLARE @DollarPurchaseIndicatorId INT = 317; -- Dollar Purchase
DECLARE @DollarSellIndicatorId INT = 318 -- Dollar Sell
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

-- xml utils
CREATE PROCEDURE getDataFromXML
	@Data XML,
	@LastUpdatedDate DATETIME OUTPUT,
	@IndicatorValue DECIMAL(12, 4) OUTPUT
AS
	;WITH XMLNAMESPACES('http://ws.sdde.bccr.fi.cr' AS ns, 
                    'urn:schemas-microsoft-com:xml-diffgram-v1' AS dg)
	SELECT 
		@LastUpdatedDate = CAST(St.value('(DES_FECHA)[1]', 'datetime') AS DATETIME),
		@IndicatorValue  = CAST(St.value('(NUM_VALOR)[1]','decimal') AS DECIMAL)
	FROM 
	@Data.nodes('/ns:DataSet/dg:diffgram/Datos_de_INGC011_CAT_INDICADORECONOMIC/INGC011_CAT_INDICADORECONOMIC')
	AS T(St);
GO

-- main procedure
CREATE PROCEDURE getExchangeRateFromBCCR 
	@IdIndicator INT,
	@StartDate DATE,
	@EndDate DATE,

	-- from web service (BCCR)
	@LastUpdateDate DATETIME OUTPUT,
	@IndicatorValue DECIMAL(12, 4) OUTPUT 
AS
BEGIN 
	TRY
        DECLARE @postData VARCHAR(500) = CONCAT(
			'Indicador=',			CAST(@IdIndicator AS NVARCHAR(10)),
			'&FechaInicio=',		FORMAT(@StartDate, 'dd/MM/yyyy'),
			'&FechaFinal=',			FORMAT(@EndDate, 'dd/MM/yyyy'),
			'&Nombre=',				'Josue Rojas Vega',
			'&SubNiveles=',			'Si',
			'&CorreoElectronico=',  'basesdedatos2.2020@gmail.com',
			'&Token=',				'2STA4UR0LM'
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

		DECLARE @Data XML = CAST(@ResponseText AS XML);

		EXEC getDataFromXML @Data, @LastUpdateDate OUTPUT, @IndicatorValue OUTPUT
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

/*
-- testing...
DECLARE @LastUpdateAt   DATETIME;
DECLARE @IndicatorValue DECIMAL(12, 4);
DECLARE @IndicatorId    INT = 317;
DECLARE @StartDate      DATE = GETDATE();
DECLARE @EndDate        DATE = GETDATE();

EXEC getExchangeRateFromBCCR 
	@IndicatorId, 
	@StartDate,
	@EndDate,
	@LastUpdateAt OUTPUT, 
	@IndicatorValue OUTPUT;

SELECT  @LastUpdateAt as LastUpdatedDate, 
		@IndicatorValue as IndicatorPrice;
*/
