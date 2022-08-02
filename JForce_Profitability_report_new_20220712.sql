DECLARE @Start_Data_Period INT = CAST(format(dateadd(month, -6, dateadd(dd, -1, getdate() )), 'yyyyMM01') AS INT);
--DECLARE @End_Data_Period INT = CONVERT(varchar(8), DATEADD(day, 0, GETDATE()), 112);

DROP TABLE IF EXISTS #TMP_FIRST_ORDER
DROP TABLE IF EXISTS #ORDERS
DROP TABLE IF EXISTS #JUMIA_NMV

SELECT
	SK_CUSTOMER_JFORCE
	, SK_SALES_ORDER
INTO #TMP_FIRST_ORDER
FROM (       
	SELECT 
		  sos.SK_CUSTOMER_JFORCE
		, sos.SK_SALES_ORDER
		, ROW_NUMBER() OVER (PARTITION BY sos.SK_CUSTOMER_JFORCE ORDER BY sos.SK_DATE ASC) as order_rank
	FROM [AIG_JUMIA_ug_DW].dbo.V_M06_F08_FCT_SALES_ORDER_SALES AS sos
	inner join AIG_JUMIA_ug_DW.dbo.[V_D34_DIM_BI_STATUS] as bi on bi.sk_bi_status = sos.sk_bi_status
	WHERE bi.DSC_BI_STATUS in ('delivered_final')
) A 
WHERE order_rank = 1;


SELECT
sois.SK_SALES_ORDER
,sos.SK_CUSTOMER_JFORCE
,MAX(CASE WHEN first_order.SK_SALES_ORDER IS NULL THEN 0 ELSE 1 END) as 'New_vs_Returning'       
,MIN(sois.SK_DELIVERY_FINAL_DATE) AS SK_DELIVERY_FINAL_DATE
,sum(sois.items_nnn) AS items_nnn
,MAX(sois.items_nnn) AS orders_nnn
,sum(sois.mv_nnn) as nmv
,sum(sois.PC1_nnn) as Operational_GP1
,sum(sois.PC2_nnn) as Operational_GP2
,avg(r.MTR_CHANGED_RATE_USD) AS Exchange_Rate
INTO #ORDERS
FROM [AIG_JUMIA_ug_DW].DBO.[V_M06_F01_FCT_SALES_ORDER_ITEM_SALES_PC2] as sois
INNER JOIN [AIG_JUMIA_ug_DW].DBO.FCT_SALES_ORDER as sos on sos.sk_sales_order = sois.SK_SALES_ORDER
inner join AIG_JUMIA_ug_DW.dbo.[V_D34_DIM_BI_STATUS] as bi on bi.sk_bi_status = sois.sk_bi_status
LEFT JOIN [AIG_JUMIA_ug_DW]..[V_AUX_CHANGED_RATE] as r on r.SK_DATE = sois.SK_DATE
LEFT JOIN #TMP_FIRST_ORDER first_order ON first_order.SK_SALES_ORDER = sois.SK_SALES_ORDER
WHERE bi.DSC_BI_STATUS in ('delivered_final')
AND sois.SK_DELIVERY_FINAL_DATE >= @Start_Data_Period
AND FLG_IS_JFORCE_AGENT_ORDER = 1

GROUP BY sois.SK_SALES_ORDER
,sos.SK_CUSTOMER_JFORCE


SELECT
LEFT(SK_DELIVERY_FINAL_DATE,6)			AS Cod_Month
,sum(sois.mv_nnn) AS JUMIA_NMV
INTO #JUMIA_NMV
FROM [AIG_JUMIA_ug_DW].DBO.[V_M06_F01_FCT_SALES_ORDER_ITEM_SALES_PC2] as sois
where sois.SK_DELIVERY_FINAL_DATE >= @Start_Data_Period
group by LEFT(SK_DELIVERY_FINAL_DATE,6)

SELECT
	LEFT(SK_DELIVERY_FINAL_DATE,6)			AS Cod_Month
	,COUNT(DISTINCT SK_CUSTOMER_JFORCE)		AS NR_CONSULTANTS
	,SUM(New_vs_Returning)					AS NR_NEW_CONSULTANTS
	,sum(items_nnn)		as Items
	,SUM(orders_nnn)	AS Orders
	,SUM(NMV)			AS NMV
	,JUMIA_NMV		
	,SUM(Operational_GP1)	AS Operational_GP1
	,SUM(Operational_GP2)	AS Operational_GP2
	,AVG(Exchange_Rate) AS Exchange_Rate
FROM #ORDERS o
inner join #JUMIA_NMV j on j.Cod_Month = LEFT(o.SK_DELIVERY_FINAL_DATE,6)
GROUP BY
	LEFT(SK_DELIVERY_FINAL_DATE,6)
	,JUMIA_NMV		