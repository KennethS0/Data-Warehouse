
USE [ROCKET-BD2]
GO

CREATE PROCEDURE GetExchangeRateForToday
AS
BEGIN
	 BEGIN TRY
		DECLARE @lastDate DATE = 
			( SELECT TOP(1) T.update_date FROM DIM_EXCHANGE_RATE T ORDER BY T.update_date desc )

		while DATEDIFF(day, @lastDate, getDate()) > 0 and 
			DATEDIFF(MINUTE,GETDATE(),DATEADD(minute, 10, DATEADD(hour, 6, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))) <= 0
		BEGIN

			DECLARE @lastUpdateDate DATE;
			DECLARE @PurchaseValue DECIMAL(15, 4), 
					@SellValue DECIMAL(15, 4);
		
			SET @lastDate = DATEADD(day, 1, @lastDate);

			-- call web service
			EXEC getExchangeRateFromBCCR
				317, 
				@lastDate, @lastDate, @lastUpdateDate out, @PurchaseValue out;

			EXEC getExchangeRateFromBCCR
				318, 
				@lastDate, @lastDate, @lastUpdateDate out, @SellValue out;

			-- update table with new exchange rate info
			INSERT INTO DIM_EXCHANGE_RATE(update_date, dollar_purchase_crc, dollar_sell_crc)
			VALUES(@lastDate, @PurchaseValue, @SellValue);
		END

	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END


-- filling exchange dimension table with data from BCCR
CREATE PROCEDURE FillExchangeDimension
AS
BEGIN

	SET NOCOUNT ON

	DELETE FROM DIM_EXCHANGE_RATE;
	DBCC CHECKIDENT('DIM_EXCHANGE_RATE', Reseed, 1)

	DECLARE @StartDate DATE = '01/01/2017';
	DECLARE @EndDate DATE = GETDATE();

	DECLARE @UpdateDate DATE;
	DECLARE @Purchase DECIMAL(10, 4), @Sell DECIMAL(10, 4); -- dollar purchase and sale (317, 318)
	DECLARE @IndicatorId INT = 317; 

	DECLARE @CurrentDate DATE = @StartDate;
	WHILE DATEDIFF(day, @CurrentDate, @EndDate) != 0 
		BEGIN
			-- call the BCCR for purchase
			EXEC getExchangeRateFromBCCR 
				317, 
				@CurrentDate, 
				@CurrentDate, 
				@UpdateDate OUT, 
				@Purchase OUT;

			WAITFOR DELAY '00:00:00.100'

			-- call the BCCR for sell
			EXEC getExchangeRateFromBCCR 
				318, 
				@CurrentDate, 
				@CurrentDate, 
				@UpdateDate OUT, 
				@Sell OUT;
		
			INSERT INTO DIM_EXCHANGE_RATE(update_date, dollar_purchase_crc, dollar_sell_crc)
			VALUES (@CurrentDate, @Purchase, @Sell)

			-- next one
			SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
		END
	print(' Exchange Rate Dimension loaded!');
END






