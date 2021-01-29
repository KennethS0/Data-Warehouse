SELECT --*
	COUNT(*) RegistrosPrincipales
FROM [dbo].[VENTAS_PROGRA2]


SELECT
	COUNT(*) AS RegistrosCR
FROM BD_COSTA_RICA.dbo.VENTAS_CR

SELECT * FROM [dbo].[FileLoadStatus]

---------------------------------------

DELETE 
TOP(90000) 
FROM [dbo].[VENTAS_PROGRA2]

DELETE FROM [BD_COSTA_RICA].[dbo].[VENTAS_CR]

DELETE FROM [dbo].[FileLoadStatus]