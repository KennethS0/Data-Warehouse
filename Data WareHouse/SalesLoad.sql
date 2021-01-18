USE [ROCKET-BD2]
GO

CREATE PROCEDURE LoadSale
	 @DocumentCode NVARCHAR(50)
	,@CreationDate DATE
	,@DueDate DATE
	,@ClientCode NVARCHAR(50)
	,@ProductCode NVARCHAR(50)
	,@ProductAmount DECIMAL(20,4)
	,@Currency NVARCHAR(50)
	,@ProductPrice DECIMAL(20,4)
	,@SaleTotal DECIMAL(20,4)
	,@WareHouseCode NVARCHAR(50)
	,@SalesPerson INT
	,@USDTotal DECIMAL(20,4)
	,@Tax DECIMAL(20,4)
	,@USDTax DECIMAL(20,4)
	,@ExchangeRateValue DECIMAL(20,4)
	,@Profit DECIMAL(20,4)
	,@USDProfit DECIMAL(20,4)
AS
BEGIN
	SELECT 'Hello world!'
END
GO

CREATE PROCEDURE SaleIsValid
	 @DocumentCode NVARCHAR(50)
	,@CreationDate DATE
	,@DueDate DATE
	,@ClientCode NVARCHAR(50)
	,@ProductCode NVARCHAR(50)
	,@ProductAmount DECIMAL(20,4)
	,@Currency NVARCHAR(50)
	,@ProductPrice DECIMAL(20,4)
	,@SaleTotal DECIMAL(20,4)
	,@WareHouseCode NVARCHAR(50)
	,@SalesPerson INT
	,@USDTotal DECIMAL(20,4)
	,@Tax DECIMAL(20,4)
	,@USDTax DECIMAL(20,4)
	,@ExchangeRateValue DECIMAL(20,4)
	,@Profit DECIMAL(20,4)
	,@USDProfit DECIMAL(20,4)
AS
BEGIN
	SELECT 'VALIDATION'
END



