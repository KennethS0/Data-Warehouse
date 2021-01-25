SELECT 
	T1.client,
	T1.salesman,
	CAST(T1.createdAt as DATE) date,
	T1.currency,
	T3.item_code,
	T3.unit_price,
	T3.amount,
	T3.tax_percentage,
	T3.untaxed_item_total,
	T3.tax_total,
	T3.profit
FROM [dbo].[sales] T1

	INNER JOIN [dbo].sales_items T2
	ON T1.ID = T2.parent_fk

	INNER JOIN [dbo].sales_items_Object T3
	ON T3.ID = T2.Object_fk

