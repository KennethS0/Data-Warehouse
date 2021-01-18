

USE [ROCKET-BD2]
GO

CREATE FUNCTION FormatCode(
	@PreCode NVARCHAR(10),
	@UnformattedCode NVARCHAR(10)
	,@NumAmount INT	
)
RETURNS
	NVARCHAR(10)
BEGIN
	RETURN @PreCode + REPLICATE('0', @NumAmount - LEN(CAST( SUBSTRING(@UnformattedCode, 2, 10) as INT ))) 
			  + CAST(CAST( SUBSTRING(@UnformattedCode, 2, 10) as INT ) AS varchar)
END












