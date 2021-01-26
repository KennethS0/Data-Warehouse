SELECT *
	--COUNT(*) RegistrosPrincipales --908884
FROM [dbo].[VENTAS_PROGRA2]
--WHERE Moneda = 'CRC'

SELECT * 
	--COUNT(*) AS RegistrosCR
FROM BD_COSTA_RICA.dbo.VENTAS_CR

SELECT * FROM [dbo].[FileLoadStatus]

---------------------------------------

DELETE FROM [dbo].[VENTAS_PROGRA2]
DELETE FROM [BD_COSTA_RICA].[dbo].[VENTAS_CR]
DELETE FROM [dbo].[FileLoadStatus]