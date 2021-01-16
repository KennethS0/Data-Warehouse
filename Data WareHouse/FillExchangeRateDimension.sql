

-- filling exchange dimension table with data from BCCR
DECLARE @StartDate DATE = '01/01/2017';
DECLARE @EndDate DATE = GETDATE();

DECLARE @UpdateDate DATE;
DECLARE @Value DECIMAL(16, 4); -- dollar purchase and sale (317, 318)
DECLARE @IndicatorId INT = 317; 

DECLARE @Progress DECIMAL(6, 2) = 0.00;
DECLARE @DateDiff_Days INT = 
	ABS(DATEDIFF(day, @EndDate, @StartDate));
DECLARE @Current DECIMAL(6, 2) = 0.00;

DECLARE @CurrentDate DATE = @StartDate;
WHILE DATEDIFF(day, @CurrentDate, @EndDate) != 0 
	BEGIN
		-- call the BCCR 
		EXEC getExchangeRateFromBCCR 
			@IndicatorId, 
			@CurrentDate, 
			@CurrentDate, 
			@UpdateDate OUT, 
			@Value OUT;

		-- to avoid DOS alerts!?
		WAITFOR DELAY '00:00:01'

		-- update progress
		SET @Progress = ( @Current / @DateDiff_Days ) * 100.00;
		PRINT( CAST(@Progress as NVARCHAR(MAX)) + '%\n');
		SET @Current = @Current + 1;

		-- next one
		SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
	END

print(' Ready!');















