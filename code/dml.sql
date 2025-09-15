-- SELECT

1 -- Seleciona o nome, email e cidade dos clientes que moram em Londres
SELECT
    p.nome,
    p.email,
    e.cidade
FROM
    Cliente AS c
JOIN
    Pessoa AS p ON c.id_pessoa = p.id_pessoa
JOIN
    Endereco AS e ON p.id_endereco = e.id_endereco
WHERE
    e.cidade = 'London';

2 -- Seleciona nome, função e data de contratação dos empregados no período especificado
SELECT
    p.nome,
    e.funcao,
    e.data_contratacao
FROM
    Empregado AS e
JOIN
    Pessoa AS p ON e.id_pessoa = p.id_pessoa
WHERE
    e.data_contratacao BETWEEN '2010-01-01' AND '2011-12-31';

3 -- Seleciona o ID da venda, a data e o valor total para as vendas no período
SELECT
    id_venda,
    data_venda,
    total
FROM
    Venda
WHERE
    data_venda BETWEEN '2012-01-01' AND '2012-01-31';

-- JUNÇAo

-- Consulta de diagnóstico: mostra todo o histórico de departamentos dos empregados
SELECT
    p.nome,
    e.funcao,
    d.nome AS nome_departamento,
    hd.data_entrada,
    hd.data_saida -- Incluímos a data de saída para verificação
FROM
    Pessoa AS p
JOIN
    Empregado AS e ON p.id_pessoa = e.id_pessoa
JOIN
    HistoricoDepartamento AS hd ON p.id_pessoa = hd.id_pessoa
JOIN
    Departamento AS d ON hd.id_departamento = d.id_departamento
ORDER BY
    p.nome, hd.data_entrada;

-- Une as tabelas Produto, Subcategoria e Categoria
SELECT
    pr.nome AS nome_produto,
    pr.preco,
    s.nome AS nome_subcategoria,
    c.nome AS nome_categoria
FROM
    Produto AS pr
JOIN
    Subcategoria AS s ON pr.id_subcategoria = s.id_subcategoria
JOIN
    Categoria AS c ON s.id_categoria = c.id_categoria;

-- Agrupamento e Agregação

-- Conta os IDs de clientes distintos da tabela Venda para o ano de 2011
SELECT
    COUNT(DISTINCT id_cliente) AS total_clientes_2011
FROM
    Venda
WHERE
    EXTRACT(YEAR FROM data_venda) = 2011;

-- Soma a coluna 'total' da tabela Venda para o ano de 2012
SELECT
    SUM(total) AS total_vendido_2012
FROM
    Venda
WHERE
    EXTRACT(YEAR FROM data_venda) = 2012;

-- Agrupa as vendas por cliente, contando o número de vendas e somando o valor total
SELECT
    p.nome,
    COUNT(v.id_venda) AS quantidade_compras,
    SUM(v.total) AS valor_total_gasto
FROM
    Venda AS v
JOIN
    Cliente AS c ON v.id_cliente = c.id_cliente
JOIN
    Pessoa AS p ON c.id_pessoa = p.id_pessoa
WHERE
    EXTRACT(YEAR FROM v.data_venda) = 2012
GROUP BY
    p.nome
ORDER BY
    valor_total_gasto DESC;

-- Agrupa por cliente e conta o número de vendas, sem filtro de ano
SELECT
    p.nome,
    COUNT(v.id_venda) AS quantidade_total_de_vendas
FROM
    Venda AS v
JOIN
    Cliente AS c ON v.id_cliente = c.id_cliente
JOIN
    Pessoa AS p ON c.id_pessoa = p.id_pessoa
GROUP BY
    p.nome
ORDER BY
    quantidade_total_de_vendas DESC;

-- Une dados de vendas e produtos e agrupa pela categoria para somar os totais
SELECT
    c.nome AS categoria,
    SUM(iv.total_item) AS total_vendido_categoria
FROM
    ItemVenda AS iv
JOIN
    Produto AS p ON iv.id_produto = p.id_produto
JOIN
    Subcategoria AS s ON p.id_subcategoria = s.id_subcategoria
JOIN
    Categoria AS c ON s.id_categoria = c.id_categoria
GROUP BY
    c.nome
ORDER BY
    total_vendido_categoria DESC;

-- Agrupa as vendas pela cidade do cliente e calcula a média do valor total
SELECT
    e.cidade,
    AVG(v.total) AS media_valor_venda
FROM
    Venda AS v
JOIN
    Cliente AS c ON v.id_cliente = c.id_cliente
JOIN
    Pessoa AS p ON c.id_pessoa = p.id_pessoa
JOIN
    Endereco AS e ON p.id_endereco = e.id_endereco
GROUP BY
    e.cidade
ORDER BY
    media_valor_venda DESC;

-- Soma as quantidades vendidas por subcategoria e filtra para mostrar apenas aquelas com mais de 100 unidades
SELECT
    s.nome AS subcategoria,
    SUM(iv.quantidade_estoque) AS unidades_vendidas 
FROM
    ItemVenda AS iv
JOIN
    Produto AS p ON iv.id_produto = p.id_produto
JOIN
    Subcategoria AS s ON p.id_subcategoria = s.id_subcategoria
GROUP BY
    s.nome
HAVING
    SUM(iv.quantidade_estoque) > 100
ORDER BY
    unidades_vendidas DESC;

-- Update e Delete]

CREATE TABLE telefone_us AS
SELECT
    t.numero,
    t.tipo,
    e.estado
FROM
    Telefone AS t
JOIN
    Pessoa AS p ON t.id_pessoa = p.id_pessoa
JOIN
    Endereco AS e ON p.id_endereco = e.id_endereco
WHERE
    e.pais = 'US';

UPDATE
    telefone_us
SET
    numero = '5' || numero -- Concatena o prefixo '5' ao número existente
WHERE
    tipo = 1 -- Filtra apenas para celulares
    AND estado IN ('CA', 'WA', 'FL', 'NY'); -- Filtra para os estados especificados

-- Primeiro, remove todos os telefones de trabalho
DELETE FROM
    telefone_us
WHERE
    tipo = 3;

-- Em seguida, remove os telefones celulares dos estados especificados
DELETE FROM
    telefone_us
WHERE
    tipo = 1
    AND estado IN ('WA', 'OR', 'CA', 'TX');