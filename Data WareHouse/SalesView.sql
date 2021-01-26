
CREATE VIEW VentasCompletas AS
SELECT 
	-- fecha completa
	T4.date_value as 'Fecha'

	-- cliente
	,T1.sn_code  as 'Codigo de cliente'
	,T1.client_name as 'Nombre de cliente'
	,T1.route_name as 'Ruta de cliente'
	,T1.zone_code as 'Codigo de zona de cliente'
	,T1.zone_name as 'Nombre de zona de cliente'

	-- tipo de cambio
	,T2.dollar_purchase_crc as 'Valor de compra del dolar en colones'
	,T2.dollar_sell_crc as 'Valor de venta del dolar en colones'

	-- producto
	,T3.aditional_id as 'Codigo de producto'
	,T3.description as 'Descripcion de producto'
	,T3.category_group as 'Categoria de producto'
	,T3.group_division as 'Division de producto'
	,T3.group_name as 'Marca de producto' --grupo

	-- tiempo
	,T4.day as 'Dia'
	,T4.month as 'Mes'
	,T4.quarter as 'Cuatrimestre'
	,T4.year as 'Anio'
	
	-- vendedor
	,T5.sales_person_code as 'Codigo de vendedor'
	,T5.sales_person_name as 'Nombre de vendedor'
	,T5.commission_percentage as 'Porcentaje de comision'
	,T5.sales_person_type as 'Tipo de vendedor'
	,T5.sales_channel as 'Canal de vendedor'

	-- venta
	,T0.sales_total as 'Total de venta'
	,T0.sales_total_usd as 'Total de venta en dolares'
	,T0.sales_tax as 'Impuesto de venta'
	,T0.sales_tax_usd as 'Impuesto de venta en dolares'
	,T0.sales_profit as 'Ganancia de venta'
	,T0.sales_profit_usd as 'Ganancia de venta en dolares'
	,T0.sales_currency as 'Moneda de venta'
	,T0.sales_price as 'Precio de venta'
	,T0.sales_product_amount as 'Cantidad de venta'

FROM
FACT_SALES T0 
	INNER JOIN DIM_CLIENT T1 
		ON T0.client_id = T1.dim_id
	INNER JOIN DIM_EXCHANGE_RATE T2 
		ON T0.exchange_rate_id = T2.dim_id
	INNER JOIN DIM_ITEM T3 
		ON T0.item_id = T3.dim_id
	INNER JOIN DIM_TIME T4 
		ON T0.time_id = T4.dim_id
	INNER JOIN DIM_SALESPERSON T5 
		ON T0.sales_person_id = T5.dim_id



