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

















