use AIG_JUMIA_KE_DW

declare @date_start int = 20220601 --CONVERT(varchar, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),112)
declare @end_start int = 20220630; --CONVERT(VARCHAR,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), 112)

WITH NET_ORDERS AS (

Select FSOIS.SK_SALES_ORDER
,MAX(items_nnn) AS ORDER_NNN
,SUM(MTR_SELLING_PRICE_EXCL_TAX) AS ORDER_VALUE
FROM [dbo].[V_M06_F02_FCT_SALES_ORDER_ITEM_SALES_USD_PC2] FSOIS
INNER JOIN [dbo].[V_M03_F01_FCT_SALES_ORDER_ITEM_FINANCE_PC2] FPC2 ON FPC2.SK_SALES_ORDER_ITEM = fsois.SK_SALES_ORDER_ITEM
WHERE FSOIS.SK_DATE between @date_start and @end_start
GROUP BY FSOIS.SK_SALES_ORDER
)

Select
 --DSOI.COD_ORDER_NR [Order Number]
 dd.COD_MONTH
,DGS.DSC_GEOGRAPHY_CITY_NAME AS [City]
,'' as [New City]
,DGS.DSC_GEOGRAPHY_REGION_NAME AS [Region]
,CASE WHEN FLG_IS_JFORCE_AGENT_ORDER = 1 THEN 'JForce'
WHEN DCH.DSC_CHANNEL_THREE LIKE '%B2B%' THEN 'B2B'
WHEN DCH.DSC_CHANNEL_TWO LIKE '%CS%' THEN 'CS Sales'
ELSE 'Customer'
END AS [Account Type]
,CASE WHEN fsois.SK_PICKUP_STATION_AT_ORDER_TIME > 0 THEN 'Pickup Station' ELSE 'Door Delivery' END AS [Door Delivery / Pickup Station]
,ISNULL(SUM(fsois.usd_mv_nnn),0) as [NMV $]
,SUM(items_nnn) as [# Delivered Items]
,ISNULL(SUM(FPC2.MTR_SELLING_PRICE_EXCL_TAX*FMKT.MTR_FINAL_NNN_VALUE_PER)/AVG(r.MTR_CHANGED_RATE_USD),0)  as [Selling Price $]
,ISNULL(SUM(FPC2.MTR_SUPPLIER_COST_EXCL_TAX*FMKT.MTR_FINAL_NNN_VALUE_PER)/AVG(r.MTR_CHANGED_RATE_USD),0) as [Supplier Cost $]
,ISNULL(SUM(fsois.usd_pc1_nnn),0) as [GP1 $]
,ISNULL(SUM(fsois.usd_shipping_revenue_nnn),0) as [shipping revenues $]
,ISNULL(SUM(((FFIN.mtr_shipping_cart_rule_discount+FFIN.mtr_international_customs_fee_cart_rule_discount + case when DSC_SALES_RULE_SET_TYPE = 'Coupon' then FFIN.mtr_shipping_voucher_discount else 0 end)/ (1 + FFIN.MTR_TAX_PERCENT/ 100))*FMKT.MTR_FINAL_NNN_VALUE_PER)/AVG(r.MTR_CHANGED_RATE_USD),0) as [shipping discount $]
,ISNULL(SUM(FFIN.MTR_COUPON_EFFECTIVE_VALUE*FMKT.MTR_FINAL_NNN_VALUE_PER)/AVG(r.MTR_CHANGED_RATE_USD),0) as [Vouchers Incl VAT (Only Coupons) $]
,ISNULL(SUM(FFIN.MTR_COUPON_EFFECTIVE_VALUE/ (1 + FFIN.MTR_TAX_PERCENT/ 100)*FMKT.MTR_FINAL_NNN_VALUE_PER)/AVG(r.MTR_CHANGED_RATE_USD),0) as [Vouchers (Only Coupons) $]
,ISNULL(SUM((fsois.usd_marketplace_comission_revenue_nnn)/ (1 + FFIN.MTR_TAX_PERCENT/ 100)),0) as [Marketplace Comission $]
,ISNULL(SUM(FFIN.MTR_CART_RULE_DISCOUNT*FMKT.MTR_FINAL_NNN_VALUE_PER)/AVG(r.MTR_CHANGED_RATE_USD),0)  as [Cart Rule Discount $]
,ISNULL(SUM(fsois.usd_MTR_LOGISTIC_FEES_VAS),0) as [Logistic Fees VAS $]
,ISNULL(SUM(fsois.usd_MTR_SUBSIDIES),0) as [Subsidies $]
,ISNULL(SUM(fsois.usd_pc2_nnn),0) as [GP2 $]
,ISNULL(SUM(FPC2.MTR_LOG_COSTS_FWD_DELIVERY)/AVG(r.MTR_CHANGED_RATE_USD),0) AS [Forward Delivery and Returns Collection $]
,ISNULL(SUM(FPC2.MTR_SELLING_PRICE_INC_TAX*FMKT.MTR_FINAL_NNN_VALUE_PER)/AVG(r.MTR_CHANGED_RATE_USD),0)  as [Selling Price Incl VAT $]
,ISNULL(SUM( CASE WHEN fsois.MTR_IS_MARKETPLACE = 1 THEN null else (FPC2.MTR_SELLING_PRICE_EXCL_TAX*FMKT.MTR_FINAL_NNN_VALUE_PER)/(r.MTR_CHANGED_RATE_USD) end) ,0) as [Retail Selling Price $]
,ISNULL(SUM( CASE WHEN fsois.MTR_IS_MARKETPLACE = 1 THEN null else (FPC2.MTR_SUPPLIER_COST_EXCL_TAX*FMKT.MTR_FINAL_NNN_VALUE_PER)/(r.MTR_CHANGED_RATE_USD) end) ,0) as [Retail Supplier Cost $]
,CASE WHEN fsois.MTR_IS_MARKETPLACE = 1 THEN 'Marketplace' else 'Retail' END AS [Business Type]
,case 
WHEN dst.DSC_SHIPPING_TYPE_DESCRIPTION in ('drop shipping','Dropshipping','Default Cross docking allow Dropshipping','Default Dropshipping allow Cross docking') THEN 'Dropshipping' 
WHEN dst.DSC_SHIPPING_TYPE_DESCRIPTION in ('warehouse','Consignment','Own Warehouse') THEN 'JExpress'
ELSE 'Other or Null' 
END as 'Shipping Type'
,SUM(NET.ORDER_NNN) AS [Net Orders]
,SUM(CASE WHEN ORDER_VALUE 
	 > 699 -- KE
	-- > 4999 -- NG
	-- > ? -- EG
THEN NET.ORDER_NNN ELSE 0 END) AS [Net Orders_Free_Shipping]
FROM
[dbo].[V_M06_F02_FCT_SALES_ORDER_ITEM_SALES_USD_PC2] FSOIS
INNER JOIN [dbo].[V_M03_F01_FCT_SALES_ORDER_ITEM_FINANCE_PC2] FPC2 ON FPC2.SK_SALES_ORDER_ITEM = fsois.SK_SALES_ORDER_ITEM
INNER JOIN [dbo].[FCT_SALES_ORDER_ITEM_FINANCE] FFIN on FFIN.SK_SALES_ORDER_ITEM = fsois.SK_SALES_ORDER_ITEM
INNER JOIN [dbo].[FCT_SALES_ORDER_ITEM_MARKETING] FMKT on FMKT.SK_SALES_ORDER_ITEM = fsois.SK_SALES_ORDER_ITEM
INNER JOIN [dbo].[FCT_SALES_ORDER] FSO ON fsois.SK_SALES_ORDER = FSO.SK_SALES_ORDER
INNER JOIN [dbo].[DIM_DATE] DD ON DD.SK_DATE = 
(CASE WHEN fsois.SK_DELIVERED_DATE <> -1 THEN fsois.SK_DELIVERED_DATE
WHEN fsois.SK_REJECTED_DATE <> -1 THEN fsois.SK_REJECTED_DATE
WHEN fsois.SK_STOCK_OUT_DATE <> -1 THEN fsois.SK_STOCK_OUT_DATE
WHEN fsois.SK_CANCELED_DATE <> -1 THEN fsois.SK_CANCELED_DATE ELSE -1 END )
INNER JOIN [dbo].[DIM_BI_STATUS] DBS on DBS.sk_bi_status = fsois.sk_bi_status
INNER JOIN [dbo].[DIM_GEOGRAPHY] DGS on DGS.SK_GEOGRAPHY = fsois.SK_GEOGRAPHY_SHIPPING
INNER JOIN [dbo].[DIM_SHIPPING_TYPE] DST on DST.SK_SHIPPING_TYPE = fsois.SK_SHIPPING_TYPE
--INNER JOIN [dbo].[DIM_SALES_ORDER_ITEM] DSOI ON DSOI.SK_SALES_ORDER_ITEM = fsois.SK_SALES_ORDER_ITEM
INNER JOIN [dbo].[DIM_CHANNEL] DCH on dch.sk_channel = FSO.sk_channel_redistributed
LEFT join  [dbo].[V_AUX_CHANGED_RATE] r on r.SK_DATE = fsois.SK_DATE
LEFT JOIN  [dbo].[DIM_SALES_RULE] DSR on DSR.sk_sales_rule = FFIN.sk_sales_rule
LEFT JOIN NET_ORDERS NET ON NET.SK_SALES_ORDER = FSOIS.SK_SALES_ORDER
WHERE DD.SK_DATE between @date_start and @end_start
and DBS.dsc_bi_status not in ('invalid','fraud')

group by
--,DSOI.COD_ORDER_NR
 DD.COD_MONTH
,DGS.DSC_GEOGRAPHY_CITY_NAME
,DGS.DSC_GEOGRAPHY_REGION_NAME
,CASE WHEN FLG_IS_JFORCE_AGENT_ORDER = 1 THEN 'JForce'
WHEN DCH.DSC_CHANNEL_THREE LIKE '%B2B%' THEN 'B2B'
WHEN DCH.DSC_CHANNEL_TWO LIKE '%CS%' THEN 'CS Sales'
ELSE 'Customer'
END
,CASE WHEN fsois.SK_PICKUP_STATION_AT_ORDER_TIME > 0 THEN 'Pickup Station' ELSE 'Door Delivery' END
,CASE WHEN fsois.MTR_IS_MARKETPLACE = 1 THEN 'Marketplace' else 'Retail' END
,case 
WHEN dst.DSC_SHIPPING_TYPE_DESCRIPTION in ('drop shipping','Dropshipping','Default Cross docking allow Dropshipping','Default Dropshipping allow Cross docking') THEN 'Dropshipping' 
WHEN dst.DSC_SHIPPING_TYPE_DESCRIPTION in ('warehouse','Consignment','Own Warehouse') THEN 'JExpress'
ELSE 'Other or Null' 
END
