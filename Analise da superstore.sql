
-- Entenda as colunas e explore o conjunto de dados
SELECT * FROM superstore LIMIT 10;

-- Receita total de vendas dos pedidos
SELECT ROUND(SUM(Vendas)) AS Total_de_Vendas FROM superstore;

-- Quantidade total de pedidos vendidos
SELECT SUM(Quantidade) AS Quantidade_Total FROM superstore;

-- Lucro total de todos os pedidos
SELECT ROUND(SUM(Lucro)) AS Total_de_lucro FROM superstore;

-- Quantidade de pedidos presentes no conjunto de dados
SELECT COUNT(ID_pedido) AS Total_Pedidos FROM superstore;

-- O desempenho das vendas e dos lucros ao longo dos anos
SELECT 
YEAR(Data_do_pedido) AS Ano,
SUM(Quantidade) AS Total_Quantidade, 
ROUND(SUM(Lucro), 2) AS Total_Lucro 
FROM 
superstore
GROUP BY YEAR(Data_do_pedido) 
ORDER BY Ano DESC;

-- Desconto e Margem de Lucro
SELECT ROUND(AVG(Desconto), 2) AS Desconto_Médio, ROUND(AVG(Lucro), 2) AS Lucro_Médio
FROM superstore;

-- As regiões com as vendas mais altas
SELECT Região,
YEAR(Data_do_pedido) AS Ano,
ROUND(SUM(Vendas), 2) AS Total_Vendas,
ROUND(SUM(Lucro), 2) AS Total_Lucro
FROM superstore
GROUP BY Região, YEAR(Data_do_pedido)
ORDER BY Total_Vendas DESC;

-- A receita total de vendas de cada região
SELECT Região,
ROUND(SUM(Vendas)) AS Receita_Total
FROM superstore
GROUP BY Região;

-- A categoria de produtos mais solicitada
SELECT Categoria, COUNT(*) AS Número_de_encomendas 
FROM superstore
GROUP BY Categoria
ORDER BY Número_de_encomendas DESC;

-- O produto mais lucrativo
SELECT Nome_do_produto, ROUND(SUM(Lucro)) AS Total_Lucro
FROM superstore 
GROUP BY Nome_do_produto
ORDER BY Total_Lucro DESC
LIMIT 1;

-- As cidades com o maior lucro
SELECT País, Cidade, 
SUM(Quantidade) AS Total_Vendido,
ROUND(SUM(Vendas), 2) AS Total_Vendas,
ROUND(SUM(Lucro), 2) AS Total_Lucro
FROM superstore 
GROUP BY País, Cidade
ORDER BY Total_Lucro DESC
LIMIT 5;

-- Os 10 primeiros clientes classificados de acordo com seus gastos totais
SELECT Nome_do_cliente,
SUM(Vendas) AS Gastos_Totais
FROM superstore
GROUP BY Nome_do_cliente
ORDER BY Gastos_Totais DESC
LIMIT 10;

-- A quantidade de pedidos realizados em cada ano
SELECT YEAR(Data_do_pedido) AS Ano,
COUNT(*) AS Total_Pedidos
FROM superstore
GROUP BY YEAR(Data_do_pedido)
ORDER BY Ano;

--  O tempo médio decorrido do pedido até a data de envio para cada opção de envio
SELECT Modo_de_envio,
AVG(DATEDIFF(Data_de_envio, Data_do_pedido)) AS Tempo_Medio_Entrega
FROM superstore
GROUP BY Modo_de_envio;

-- O desconto médio aplicado nas encomendas
SELECT ROUND(AVG(Desconto), 2) AS Desconto_Medio
FROM superstore;

-- Padrões de vendas ao longo do ano: Segmentos e Categorias
SELECT 
    YEAR(Data_do_pedido) AS Ano,
    MONTH(Data_do_pedido) AS Mês,
    Segmento,
    Categoria,
    ROUND(AVG(Vendas), 2) AS Vendas_Medio
FROM (
    SELECT
        Data_do_pedido,
        Segmento,
        Categoria,
        Vendas,
        AVG(Vendas) OVER (PARTITION BY Segmento, Categoria ORDER BY Data_do_pedido 
        ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS Média_Móvel_Vendas
    FROM superstore
) AS subquery
GROUP BY Ano, Mês, Segmento, Categoria
ORDER BY Ano, Mês, Segmento, Categoria;

-- Média de Desconto por Categoria de Produto
SELECT 
	Categoria,
    ROUND(AVG(Desconto), 2) AS Desconto_Medio
FROM
	superstore
GROUP BY
	Categoria;
    
-- Detalhes de Preços, Descontos e perdas por Produto
SELECT 
	ID_produto,
    Nome_do_produto,
    Vendas AS Preco_Original,
    Desconto,
    ROUND((Desconto / Vendas) * 100, 2) AS Percentual_Desconto,
    ROUND(Vendas - (Desconto / 1 - (Desconto / Vendas)), 2) AS Perda
FROM
	superstore;

-- As tendências sazonais e mensais para identificar padrões de vendas ao longo do ano
SELECT 
    YEAR(Data_do_pedido) AS Ano,
    MONTH(Data_do_pedido) AS Mes,
    ROUND(SUM(Vendas), 2) AS Total_Vendas
FROM
    superstore
GROUP BY Ano, Mes
ORDER BY Ano, Mes;

-- Avaliação do impacto dos descontos nas vendas e lucratividade
SELECT
	IF(Desconto > 0, 'Com Desconto', 'Sem Desconto') AS Tipo_Desconto,
    ROUND(SUM(Vendas), 2) AS Total_Vendas,
    ROUND(SUM(Lucro), 2) AS Total_Lucro
FROM
	superstore
GROUP BY Tipo_Desconto;
    
-- Segmentação dos clientes com base em seu comportamento de compra  
SELECT 
    CASE 
        WHEN Gastos_Totais < 1000 THEN 'Cliente Regular'
        WHEN Gastos_Totais >= 1000 AND Gastos_Totais < 5000 THEN 'Cliente Premium'
        ELSE 'Cliente VIP'
    END AS Segmento_Cliente,
    COUNT(*) AS Numero_de_Clientes,
    ROUND(SUM(Gastos_Totais), 2) AS Receita_Total
FROM (
    SELECT 
        Nome_do_cliente,
        SUM(Vendas) AS Gastos_Totais
    FROM
        superstore
    GROUP BY Nome_do_cliente
) AS subquery
GROUP BY Segmento_Cliente;

-- A rentabilidade de cada produto considerando os custos associados
SELECT 
    Nome_do_produto,
    ROUND(SUM(Vendas), 2) AS Receita_Total,
    ROUND(SUM(Lucro), 2) AS Lucro_Total,
    ROUND(SUM(Lucro) / SUM(Vendas), 2) AS Margem_Lucro
FROM
    superstore
GROUP BY Nome_do_produto
ORDER BY Margem_Lucro DESC;

-- Avaliação da taxa de retenção de clientes ao longo do tempo
SELECT 
    YEAR(Data_do_pedido) AS Ano,
    COUNT(DISTINCT Nome_do_cliente) AS Clientes_unicos
FROM
    superstore
GROUP BY Ano;

