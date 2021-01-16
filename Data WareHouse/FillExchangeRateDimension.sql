
USE [ROCKET-BD2]
GO

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






