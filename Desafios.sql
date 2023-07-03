# Quantos pedidos foram feitos em cada um dos anos seguintes? Certifique-se de selecionar TODAS as respostas corretas
SELECT OD.OrderID, OD.Quantity, O.OrderID, O.Orderdate FROM OrderDetails as OD join Orders as O on OD.OrderID = O.OrderID
where O.Orderdate like '1996%'
group by O.OrderID
Order by O.OrderID;

# Crie uma consulta para agrupar o número de pedidos feitos de países da 
# Europa e do resto do mundo. Quantos pedidos foram feitos por cada um?
SELECT COUNT(*) AS TOT_ORDERS,
CASE
WHEN Customers.Country IN ('Finland', 'France', 'Belgium', 'Switzerland', 'Austria', 'Sweden', 'Germany', 
'Italy', 'Spain', 'UK', 'Ireland', 'Portugal', 'Denmark', 'Poland', 'Norway') THEN 'EUROPE'
ELSE 'REST OF THE WORLD'
END AS Location
FROM Orders, Customers
WHERE Orders.CustomerID = Customers.CustomerID
GROUP BY Location;

# Crie uma consulta para somar por País, o total de pedidos, a quantidade total de itens 
# e a proporção de itens por pedido. Qual é o país com a maior proporção de itens por pedido?
SELECT Customers.Country, (SUM(OrderDetails.Quantity) / Count(Orders.OrderID)) 
AS ProportionQTDbyOrders FROM Orders, Customers, OrderDetails WHERE Orders.CustomerID = Customers.CustomerID 
AND Orders.OrderID = OrderDetails.OrderID 
GROUP BY Customers.Country 
order by ProportionQTDbyOrders;

# Crie uma Consulta para mostrar o número de produtos distintos por pedido, o total de itens por pedido, 
# o preço médio do item por pedido e o preço mais alto do item por pedido. Com base no resultado dessa 
# consulta, qual foi o OrderID com mais produtos distintos?
SELECT DISTINCT Products.ProductName AS Product, SUM(OrderDetails.Quantity) AS TOT_Itens, AVG(Products.Price) AS AVG_PRICE, 
MAX(Products.Price) AS MAX_PRICE, COUNT(Orders.OrderID) AS COUNT_OID, Orders.OrderID
FROM Orders, OrderDetails, Products
WHERE Orders.OrderID = OrderDetails.OrderID AND
OrderDetails.ProductID = Products.ProductID
GROUP BY Orders.OrderID
ORDER BY COUNT_OID DESC;

# Selecione uma lista com o nome de todas as gafanhotas
select nome from gafanhotos
where sexo = 'f' or 'F'
order by nome;

# Selecione uma lista com os dados que todos aqueles que nasceram entre 01-01-2000 e 31-12-2015
select nome, nascimento from gafanhotos
where nascimento between '2000-01-01' and '2015-12-31'
order by nascimento;

# Uma lista com o nome de todos os homens que trabalham como programador
select nome, profissao, sexo from gafanhotos
where profissao = 'programador' and sexo = 'm' or 'M';

# Uma lista com os dados das mulheres que nasceram no brasil e tem o nome iniciado com 'J'
select * from gafanhotos
where nacionalidade = 'Brasil' and nome like 'j%' and sexo = 'F' or 'f';

# Uma lista com o nome e nacionalidade de todos os homens que tenham silva, nao nasceram no brasil e tem menos de 100kg
select nome, nacionalidade, sexo from gafanhotos
where nome like '%silva%' and nacionalidade != 'Brasil' and peso < '100';

# Qual a maior altura entre os gafanhotos homens que moram no brasil
select max(altura) from gafanhotos
where nacionalidade = 'Brasil';

# Qual o menor peso das mulheres que nasceram fora do brasil entre 01-01-1990 e 31-12-2000
select min(peso) from gafanhotos
where sexo = 'm' or 'M' and nacionalidade != 'Brasil' and nascimento between '1990-01-01' and '2000-12-31';
 
# Quantas mulheres tem mais de 1.90cm de altura
select nome, sexo,altura from gafanhotos
where altura > '1.90' and sexo = 'f' or 'F';

-- 1- Qual o nome do produto (e quantidade) mais vendido (em unidades) em 2021 da BI_CATEGORY_ONE = Adulte

-- SELECIONA O ITEM COM MAIOR QUANTIDADE VENDIDA EM 2021 NA CATEGORIA ADULTO TEMPO DE CURSO MAISOU MENOS 00:00:04
SELECT TOP 1
	COUNT(FSOI.SK_PRODUCT) AS QTD_PROD
	,db.DSC_PRODUCT_NAME AS PROD_NAME
	,DB.DSC_BI_PRODUCT_CATEGORY_ONE AS PROD_CAT
	,FSOI.SK_DATE
FROM 
	FCT_SALES_ORDER_ITEM AS FSOI
	INNER JOIN DIM_PRODUCT AS DB
	ON FSOI.SK_PRODUCT = DB.SK_PRODUCT
WHERE DB.DSC_BI_PRODUCT_CATEGORY_ONE IN ('Adulte','adulte') AND FSOI.SK_DATE BETWEEN '20210101' AND '20211231'
GROUP BY 
	 FSOI.SK_PRODUCT
	,db.DSC_PRODUCT_NAME
	,DB.DSC_BI_PRODUCT_CATEGORY_ONE
	,FSOI.SK_DATE
ORDER BY QTD_PROD DESC
	

-- 3. Qual o nome do produto vendido em 2022 com o maior valor (utilizem o campo MTR_GMV_INCL_TAX da tabela V_M06_F01_FCT_SALES_ORDER_ITEM_SALES em LCY 
--(local currency, o valor que já lá está), mas também em EUR e USD (via tabela V_AUX_CHANGED_RATE)
-- Oque eu usei, 2 inner join, format para definir a divisão dos valores dastabelas e informar o padrão que deveriam apresentar
-- RETORNA UNICAMENTE O ITEM COM MAIOR VALOR TEMPO DE CURSO MAIS OU MENOS 00:00:17
SELECT TOP 1
	 VSOI.SK_PRODUCT
	,FORMAT(VSOI.MTR_GMV_INCL_TAX /ACR.MTR_CHANGED_RATE_EUR,'C', 'pt-PT') AS PR_EUR
	,FORMAT(VSOI.MTR_GMV_INCL_TAX/ACR.MTR_CHANGED_RATE_USD,'C', 'en-US')  AS PR_DOLLAR
	,VSOI.SK_DATE
	,DP.DSC_PRODUCT_NAME
	,DP.DSC_PRODUCT_BRAND_NAME
from V_M06_F01_FCT_SALES_ORDER_ITEM_SALES AS VSOI
	INNER JOIN V_AUX_CHANGED_RATE AS ACR
	ON VSOI.SK_DATE = ACR.SK_DATE
	INNER JOIN DIM_PRODUCT AS DP
	ON VSOI.SK_PRODUCT = DP.SK_PRODUCT
where VSOI.SK_DATE between 20220101 and 20221231
group by VSOI.SK_PRODUCT,
VSOI.MTR_GMV_INCL_TAX,
ACR.MTR_CHANGED_RATE_EUR,
ACR.MTR_CHANGED_RATE_USD,
VSOI.SK_DATE,
DP.DSC_PRODUCT_NAME,
DP.DSC_PRODUCT_BRAND_NAME
order by PR_EUR DESC,
PR_DOLLAR DESC;

-- RETORNA OS ITEMS COM MAIOR VALOR TEMPO DE CURSO MAIS OU MENOS 00:00:50

SELECT
	 VSOI.SK_PRODUCT
	,FORMAT(VSOI.MTR_GMV_INCL_TAX /ACR.MTR_CHANGED_RATE_EUR,'C', 'pt-PT') AS PR_EUR
	,FORMAT(VSOI.MTR_GMV_INCL_TAX/ACR.MTR_CHANGED_RATE_USD,'C', 'en-US')  AS PR_DOLLAR
	,VSOI.SK_DATE
	,DP.DSC_PRODUCT_NAME
	,DP.DSC_PRODUCT_BRAND_NAME
from
	V_M06_F01_FCT_SALES_ORDER_ITEM_SALES AS VSOI
	INNER JOIN V_AUX_CHANGED_RATE AS ACR ON VSOI.SK_DATE = ACR.SK_DATE
	INNER JOIN DIM_PRODUCT AS DP ON VSOI.SK_PRODUCT = DP.SK_PRODUCT
where 
	VSOI.SK_DATE between 20220101 and 20221231
group by
	VSOI.SK_PRODUCT,
	VSOI.MTR_GMV_INCL_TAX,
	ACR.MTR_CHANGED_RATE_EUR,
	ACR.MTR_CHANGED_RATE_USD,
	VSOI.SK_DATE,
	DP.DSC_PRODUCT_NAME,
	DP.DSC_PRODUCT_BRAND_NAME
order by 
	PR_EUR DESC,
	PR_DOLLAR DESC;
	
-- Qual é a percentagem, por país e para os últimos 3 anos (desde 2020), de ordens delivered (sobre ordens gross)

SELECT
	C.DSC_COUNTRY_SMALL,
	DD.COD_YEAR,
	SUM(FO.MTR_GROSS_ORDERS) AS NR_GROSS_ORDERS,
	SUM(FO.FLG_DELIVERED_ORDER) AS NR_DELIVERED_ORDERS,
	SUM(FO.FLG_DELIVERED_ORDER) * 1.0 / SUM(FO.MTR_GROSS_ORDERS) AS GROSS_TO_NET_RATIO
FROM 
	DW.FCT_ORDERS AS FO
	INNER JOIN DW.D_DATE AS DD ON DD.SK_DAY = FO.SK_DT_ORDER_CREATION
	INNER JOIN _AUX.COUNTRIES AS C ON C.COD_COUNTRY = FO.COD_COUNTRY
WHERE 
	FO.SK_DT_ORDER_CREATION >= 20200101
GROUP BY 
	C.DSC_COUNTRY_SMALL,
	DD.COD_YEAR
order by 
	C.DSC_COUNTRY_SMALL,
	DD.COD_YEAR
	
-- a) todos os status = 53
SELECT
	C.DSC_COUNTRY_SMALL
	,COUNT(*) AS NR_STATUS_53
	,COUNT(DISTINCT FOW.COD_ORDER_HASH) AS NR_ORDERS
	,AVG(DATEDIFF(SECOND,FOW.MTR_DT_TRANSITION,FOW.MTR_DT_NEXT_TRANSITION)) AS AVG_SS_NEXT_STATUS
FROM DW.FCT_ORDER_WORKFLOW FOW
INNER JOIN DW.D_ORDER_STATUS DOS ON DOS.SK_ORDER_STATUS = FOW.SK_STATUS
INNER JOIN _AUX.COUNTRIES C ON C.COD_COUNTRY = FOW.COD_COUNTRY
INNER JOIN DW.D_DATE DD ON DD.SK_DAY = FOW.SK_DT_ORDER_CREATION
WHERE 1=1
--AND COD_ORDER_HASH = 'a0bc-x1gs'
AND FOW.SK_DT_ORDER_CREATION >= 20220101
AND DOS.COD_BE_ORDER_STATUS = '53'
GROUP BY 	C.DSC_COUNTRY_SMALL

--b) apenas o último em ordens com > 1x no status = 53
WITH ORDERS AS (

SELECT
	FOW.COD_ORDER_HASH
FROM DW.FCT_ORDER_WORKFLOW FOW
INNER JOIN DW.D_ORDER_STATUS DOS ON DOS.SK_ORDER_STATUS = FOW.SK_STATUS
WHERE 1=1
AND FOW.SK_DT_ORDER_CREATION >= 20220101
AND DOS.COD_BE_ORDER_STATUS = '53'
GROUP BY FOW.COD_ORDER_HASH
HAVING COUNT(*) > 1
)

SELECT 
	DSC_COUNTRY_SMALL
	,COUNT(*) AS NR_ORDERS
	,AVG(SS_NEXT_STATUS) AS AVG_SS_NEXT_STATUS
FROM (
	SELECT
		C.DSC_COUNTRY_SMALL
		,FOW.COD_ORDER_HASH
		,DATEDIFF(SECOND,FOW.MTR_DT_TRANSITION,FOW.MTR_DT_NEXT_TRANSITION) AS SS_NEXT_STATUS
		,ROW_NUMBER() OVER (PARTITION BY FOW.COD_ORDER_HASH ORDER BY FOW.COD_WORKFLOW DESC) AS RANK
	FROM DW.FCT_ORDER_WORKFLOW FOW
	INNER JOIN ORDERS O ON O.COD_ORDER_HASH = FOW.COD_ORDER_HASH
	INNER JOIN DW.D_ORDER_STATUS DOS ON DOS.SK_ORDER_STATUS = FOW.SK_STATUS
	INNER JOIN _AUX.COUNTRIES C ON C.COD_COUNTRY = FOW.COD_COUNTRY
	INNER JOIN DW.D_DATE DD ON DD.SK_DAY = FOW.SK_DT_ORDER_CREATION
	WHERE 1=1
	AND DOS.COD_BE_ORDER_STATUS = '53'
) A
WHERE A.RANK = 1
GROUP BY
	A.DSC_COUNTRY_SMALL


--Qual é a média do delivery time, por vendor type, no primeiro e segundo trimestres de 2022 (Q1 e Q2); média dos 3 países com mais ordens YTD (desde o início do ano)
SELECT
	 C.DSC_COUNTRY_SMALL
	,DVT.DSC_VENDOR_TYPE
	--,DD.COD_TRIMESTER
	,AVG(CASE WHEN DD.COD_TRIMESTER = '2022T1' THEN MTR_MM_DELIVERY_TIME ELSE NULL END) AS DT_2022_T1
	,AVG(CASE WHEN DD.COD_TRIMESTER = '2022T2' THEN MTR_MM_DELIVERY_TIME ELSE NULL END) AS DT_2022_T2
FROM
	DW.FCT_ORDERS AS FO
	INNER JOIN _AUX.COUNTRIES AS C ON FO.COD_COUNTRY = C.COD_COUNTRY
	INNER JOIN DW.D_DATE AS DD ON DD.SK_DAY = FO.SK_DT_ORDER_CREATION
	INNER JOIN DW.D_VENDOR dv ON dv.SK_VENDOR = fo.SK_VENDOR
	INNER JOIN DW.D_VENDOR_TYPE AS DVT ON DVT.SK_VENDOR_TYPE = dv.SK_VENDOR_TYPE
WHERE 1=1
	AND FO.SK_DT_ORDER_CREATION >= 20220101
GROUP BY
	 DVT.DSC_VENDOR_TYPE
	--,DD.COD_TRIMESTER
	,C.DSC_COUNTRY_SMALL

-- Qual é a distribuição dos pedidos por hora do dia. Egipto, last week (segunda a domingo)
-- quero que apareca mesmo que o count dê zero
-- quero saber qual é a % de cada uma das horas sobre o total
WITH TEMP AS(
SELECT
	dt.HOUR_24
	,SUM(CASE WHEN SK_DT_ORDER_CREATION BETWEEN 20220516 AND 20220522 THEN 1 ELSE 0 END) as QTD_ORD_HR
FROM
	DW.FCT_ORDERS fo
	RIGHT JOIN DW.D_TIME dt ON dt.SK_TIME = fo.SK_TIME_ORDER_CREATION
	INNER JOIN _AUX.COUNTRIES c ON fo.COD_COUNTRY = c.COD_COUNTRY
WHERE
	c.DSC_COUNTRY_SMALL = 'EG'
GROUP BY
	dt.HOUR_24
),
TEMP1 AS(
SELECT
SUM (TEMP.QTD_ORD_HR) AS SOMA
FROM TEMP
)
SELECT
	 TEMP.HOUR_24
	,TEMP.QTD_ORD_HR
	,ROUND (((TEMP.QTD_ORD_HR)*1.0 / TEMP1.SOMA)*100,2) AS PERC_TT
FROM TEMP,TEMP1
ORDER BY HOUR_24

SELECT
   NM_APPLICATION,
   NM_LANGUAGE,
   Z_MDU_INSERT_DT,
   SUM(CASE WHEN NM_APPLICATION <> '' THEN 1 ELSE 0 END) AS QTD_REGISTROS
FROM 
  cur_qs.o_dvscops_app_source_code_management
--WHERE 
  --NM_LANGUAGE like
GROUP BY   
  NM_APPLICATION,
  NM_LANGUAGE,
  Z_MDU_INSERT_DT
HAVING
  SUM(CASE WHEN NM_APPLICATION <> '' THEN 1 ELSE 0 END) > 1
ORDER BY
  QTD_REGISTROS DESC

