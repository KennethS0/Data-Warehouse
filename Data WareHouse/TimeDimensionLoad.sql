USE [ROCKET-BD2]
GO

CREATE PROCEDURE FillTimeDimension
	@InitialDate DATE
AS
BEGIN

	EXEC ResetTable 'DIM_TIME'

	INSERT INTO DIM_TIME
	SELECT
		--T0.number+1
		DATEADD(DAY, T0.number, @InitialDate)
		, MONTH(DATEADD(DAY, T0.number, @InitialDate))
		, RIGHT('0' + CAST(MONTH(DATEADD(DAY, T0.number, @InitialDate)) as nvarchar(2)), 2)
		, YEAR(DATEADD(DAY, T0.number, @InitialDate) )
		, DAY(DATEADD(DAY, T0.number, @InitialDate) )
		, DATEPART(qq, DATEADD(day, T0.number, @InitialDate) )
	FROM master.dbo.spt_values T0 
	WHERE T0.type = 'P'
	ORDER BY T0.number
END


EXEC FillTimeDimension '2017-01-01'

SELECT * FROM DIM_TIME ORDER BY DATE_VALUE ASC






