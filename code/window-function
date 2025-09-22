-- Aula Trabalho 4

-- A) 
SELECT
    e.pais,
    e.estado,
    e.cidade,
    SUM(v.total) AS valor_total_vendido
FROM
    Venda AS v
JOIN
    Cliente AS c ON v.id_cliente = c.id_cliente
JOIN
    Pessoa AS p ON c.id_pessoa = p.id_pessoa
JOIN
    Endereco AS e ON p.id_endereco = e.id_endereco
GROUP BY
    ROLLUP(e.pais, e.estado, e.cidade)
ORDER BY
    e.pais, e.estado, e.cidade;

-- B
SELECT
    EXTRACT(YEAR FROM data_venda) AS ano,
    EXTRACT(MONTH FROM data_venda) AS mes,
    COUNT(id_venda) AS quantidade_vendas,
    SUM(total) AS valor_total_vendido
FROM
    Venda
GROUP BY
    ROLLUP(ano, mes)
ORDER BY
    ano, mes;

-- 2) a)
SELECT
    cat.nome AS categoria_produto,
    vend.nome AS nome_vendedor,
    SUM(iv.quantidade_estoque) AS total_itens_vendidos, --  "quantidade_estoque" em ItemVenda é quantidade vendid
    SUM(iv.total_item) AS valor_total
FROM
    ItemVenda AS iv
JOIN
    Venda AS v ON iv.id_venda = v.id_venda
-- LEFT JOIN para incluir vendas que podem não ter um vendedor associado
LEFT JOIN
    Pessoa AS vend ON v.id_vendedor = vend.id_pessoa
JOIN
    Produto AS p ON iv.id_produto = p.id_produto
JOIN
    Subcategoria AS sub ON p.id_subcategoria = sub.id_subcategoria
JOIN
    Categoria AS cat ON sub.id_categoria = cat.id_categoria
GROUP BY
    CUBE(categoria_produto, nome_vendedor)
ORDER BY
    categoria_produto, nome_vendedor;

-- 3) abc
SELECT
    e.estado,
    c.cartao_tipo,
    COUNT(DISTINCT c.id_cliente) AS quantidade_clientes
FROM
    Cliente AS c
JOIN
    Pessoa AS p ON c.id_pessoa = p.id_pessoa
JOIN
    Endereco AS e ON p.id_endereco = e.id_endereco
GROUP BY
    GROUPING SETS((e.estado), (c.cartao_tipo))
ORDER BY
    e.estado, c.cartao_tipo;

-- 4) abc
SELECT
    d.nome AS departamento,
    e.funcao,
    COUNT(DISTINCT e.id_pessoa) AS quantidade_empregados
FROM
    Empregado AS e
JOIN
    Pessoa AS p ON e.id_pessoa = p.id_pessoa
JOIN
    HistoricoDepartamento AS hd ON e.id_pessoa = hd.id_pessoa
JOIN
    Departamento AS d ON hd.id_departamento = d.id_departamento
WHERE
    hd.data_saida IS NULL -- Considera apenas o departamento atual de cada empregado
GROUP BY
    GROUPING SETS((departamento), (e.funcao), ())
ORDER BY
    departamento, e.funcao;

-- fim aula 4 - T4
