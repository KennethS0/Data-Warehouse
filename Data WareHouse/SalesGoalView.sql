CREATE VIEW MetasDeVenta AS
SELECT
	 T0.brand_code as 'Marca'
	,T0.sales_goal_code as 'Codigo de meta de venta'
	,T0.year as 'Año'
	,T0.month_numeric as 'Mes numerico'
	,DATENAME(month, 
		CAST(
			REPLICATE('0', 2 - len( CAST(T0.month_numeric as nvarchar(max)) )) + cast (T0.month_numeric as varchar) +
			'/01/2000'
			AS DATE)) as 'Mes'
	,T1.sales_person_name as 'Nombre de vendedor'
	,T1.sales_person_code as 'Codigo de vendedor'
	,T1.sales_person_type as 'Tipo de Vendedor'
	,T1.sales_channel as 'Canal de vendedor'
	,T0.sales_goal as 'Meta de Venta'

FROM FACT_SALES_GOAL T0 
	INNER JOIN DIM_SALESPERSON T1 ON T0.sales_person_id = T1.dim_id;






