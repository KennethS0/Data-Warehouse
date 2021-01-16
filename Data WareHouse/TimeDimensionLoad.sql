USE [ROCKET-BD2]
GO

CREATE PROCEDURE TimeDimensionGeneration
	@InitialDate DATE,
AS

INSERT INTO [DW_VENTAS_JOINS].[dbo].[DIM_TIME]
SELECT 
	T0.number+1
	, DATEADD(DAY, T0.number, '2020-01-01')
	, MONTH(DATEADD(DAY, T0.number, '2020-01-01'))
	, RIGHT('0' + CAST(MONTH(DATEADD(DAY, T0.number, '2020-01-01')) as nvarchar(2)), 2)
	, YEAR(DATEADD(DAY, T0.number, '2020-01-01') )
	, DAY(DATEADD(DAY, T0.number, '2020-01-01') )
	, DATEPART(qq, DATEADD(day, T0.number, '2020-01-01') )
FROM master.dbo.spt_values T0 
WHERE T0.type = 'P'
ORDER BY T0.number



CREATE TABLE test (
	id INT
)

INSERT INTO test SELECT 
T0.number + 1,
MAX(T0.number + 1), MIN(T0.number + 1)
FROM master.dbo.spt_values T0 
WHERE T0.type = 'P' GROUP BY T0.type

SELECT COUNT(T0.number), MAX(T0.number), MIN(T0.number) from master.dbo.spt_values T0 

delete from test




