-- =================================================================
-- Script de Criação de Tabelas - LAB-BD-PAE
-- PAE: Leonardo Campos
-- =================================================================

CREATE TABLE Endereco (
	id_endereco				INT NOT NULL,
	rua						VARCHAR(60) NULL,
	cidade					VARCHAR(30) NOT NULL,
	estado 					VARCHAR(30) NOT NULL,
	pais					VARCHAR(30) NOT NULL,
	CONSTRAINT pk_endereco PRIMARY KEY (id_endereco)
);

CREATE TABLE Pessoa (
	id_pessoa				INT NOT NULL,
	nome					VARCHAR(200) NOT NULL,
	senha					VARCHAR(200) NOT NULL,
	email 					VARCHAR(200) NOT NULL,
	id_endereco 			INT NOT NULL,
	CONSTRAINT pk_pessoa PRIMARY KEY (id_pessoa),
    CONSTRAINT fk_pessoa_endereco FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco) ON DELETE CASCADE
);

CREATE TABLE Telefone (
	id_pessoa 				INT NOT NULL,
	numero 					VARCHAR(30) NOT NULL,
	tipo					INT NOT NULL,
	CONSTRAINT pk_telefone PRIMARY KEY (id_pessoa, numero, tipo),
	CONSTRAINT fk_pessoa_telefone FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa) ON DELETE CASCADE
);

CREATE TABLE Empregado (
	id_pessoa 				INT NOT NULL,
	documento				VARCHAR(20) NOT NULL,
	funcao	 				VARCHAR(50) NOT NULL,
	data_contratacao 		DATE NOT NULL,
	login  					VARCHAR(256) NOT NULL,
	estado_civil 			NCHAR(1) NOT NULL,
	sexo		 			NCHAR(1) NOT NULL,
	data_nascimento 		DATE NOT NULL,
	CONSTRAINT pk_empregado PRIMARY KEY (documento),
	CONSTRAINT fk_pessoa_empregado FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa) ON DELETE CASCADE
);

CREATE TABLE Departamento (
	id_departamento 		INT NOT NULL,
	nome 					VARCHAR(200) NOT NULL,
	grupo 					VARCHAR(200) NOT NULL,
	CONSTRAINT pk_departamento PRIMARY KEY (id_departamento),
	CONSTRAINT check_nome_grupo
 		CHECK (grupo IN ('Executive General and Administration', 'Inventory Management', 'Manufacturing', 'Quality Assurance', 'Research and Development', 'Sales and Marketing'))
);

CREATE TABLE HistoricoDepartamento (
	id_pessoa				INT NOT NULL,
	id_departamento 		INT NOT NULL,
	turno					VARCHAR(10),
	data_entrada			DATE NOT NULL,
	data_saida				DATE,
	CONSTRAINT pk_historicodepartamento PRIMARY KEY (id_pessoa, id_departamento, data_entrada),
	CONSTRAINT fk_pessoa_histdep FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa),
	CONSTRAINT fk_dep_histdep FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento),
	CONSTRAINT check_turno_trabalho
 		CHECK (turno IN ('dia','tarde','noite'))
);

-- Trocar o NUMBER por NUMERIC

CREATE TABLE Vendedor (
	id_pessoa				INT NOT NULL,
	bonus 					NUMERIC(15,2) NOT NULL,
	comissao 				NUMERIC(15,2) NOT NULL,
	vendas_ano 				NUMERIC(15,2) NOT NULL,
	vendas_ano_anterior 	NUMERIC(15,2) NOT NULL,
	cota_vendas				NUMERIC(15,2) NOT NULL,
	CONSTRAINT pk_vendedor PRIMARY KEY (id_pessoa),
	CONSTRAINT fk_pessoa_vendedor FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa) ON DELETE CASCADE
);

CREATE TABLE Cliente (
	id_cliente 				INT NOT NULL,
	id_pessoa				INT NOT NULL,
	cartao_tipo				VARCHAR(50) NOT NULL,
	cartao_numero			VARCHAR(50) NOT NULL,
	cartao_validade_mes		SMALLINT,
	cartao_validade_ano		SMALLINT,
	CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
	CONSTRAINT fk_pessoa_cliente FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa) ON DELETE CASCADE
);

CREATE TABLE Categoria (
	id_categoria			INT NOT NULL,
	nome					VARCHAR(20) NOT NULL,
	CONSTRAINT pk_categoria PRIMARY KEY (id_categoria)
);

CREATE TABLE Subcategoria (
	id_subcategoria			INT NOT NULL,
    id_categoria			INT NOT NULL,
	nome					VARCHAR(20) NOT NULL,
	CONSTRAINT pk_subcategoria PRIMARY KEY (id_subcategoria),
    CONSTRAINT pk_subcat_cat FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria) ON DELETE CASCADE
);

CREATE TABLE Produto (
	id_produto				INT NOT NULL,
	nome					VARCHAR(250) NOT NULL,
	numero_produto			VARCHAR(250) NOT NULL,
	preco 					NUMERIC NOT NULL,
	id_subcategoria			INT NOT NULL,
	cor 					VARCHAR(25),
	tamanho 				VARCHAR(10),
	peso 					NUMERIC(8,2),
	descricao				VARCHAR(2500),
	quantidade				SMALLINT,
	modelo					VARCHAR(50),
	CONSTRAINT pk_produto PRIMARY KEY (id_produto),
	CONSTRAINT fk_produto_subcat FOREIGN KEY (id_subcategoria) REFERENCES Subcategoria(id_subcategoria) ON DELETE CASCADE
);

CREATE TABLE Venda (
	id_venda				INT NOT NULL,
	id_cliente				INT NOT NULL,
	id_vendedor				INT,
	data_venda				DATE NOT NULL,
	data_vencimento			DATE NOT NULL,
	status 					SMALLINT NOT NULL,
	subtotal				NUMERIC NOT NULL,
	codigo_aprovacao_cartao	VARCHAR(15),
	data_envio				DATE NOT NULL,
	valor_frete				NUMERIC NOT NULL,
	total					NUMERIC NOT NULL,
	CONSTRAINT pk_venda PRIMARY KEY (id_venda),
	CONSTRAINT fk_cliente_venda FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE,
	CONSTRAINT fk_vendedor_venda FOREIGN KEY (id_vendedor) REFERENCES Pessoa(id_pessoa) ON DELETE CASCADE
);

CREATE TABLE ItemVenda (
	id_item					INT NOT NULL,
	id_venda				INT NOT NULL,
	id_produto				INT NOT NULL,
	codigo_rastreio			VARCHAR(50),
	quantidade_estoque		SMALLINT,
	preco_unitario			NUMERIC,
	desconto				NUMERIC,
	total_item				NUMERIC,
	CONSTRAINT pk_itemvenda PRIMARY KEY (id_item),
	CONSTRAINT fk_venda_itemvenda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda) ON DELETE CASCADE,
	CONSTRAINT fk_produto_itemvenda FOREIGN KEY (id_produto) REFERENCES Produto(id_produto) ON DELETE CASCADE
);


-- =================================================================
-- Script de Inserção de Dados - LAB-BD-PAE
-- RODAR NO TERMINAL... NÃO FUNCIONA EM SOFTWARES GRÁFICOS...
-- =================================================================

-- TEM QUE SER NA ORDEM...

-- 1. Tabelas sem dependências externas
\echo 'Carregando Endereco...'
\copy Endereco FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tendereco.csv' WITH (FORMAT CSV, HEADER);

\echo 'Carregando Departamento...'
\copy Departamento FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tdepartment.csv' WITH (FORMAT CSV, HEADER);

\echo 'Carregando Categoria...'
\copy Categoria FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tcategoria.csv' WITH (FORMAT CSV, HEADER);

-- 2. Tabelas que dependem do primeiro grupo
\echo 'Carregando Pessoa...'
\copy Pessoa FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tpessoa.csv' WITH (FORMAT CSV, HEADER);

\echo 'Carregando Subcategoria...'
\copy Subcategoria FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tsubcategoria.csv' WITH (FORMAT CSV, HEADER);

-- 3. Tabelas que dependem de Pessoa
\echo 'Carregando Telefone...'
\copy Telefone FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/ttelefone.csv' WITH (FORMAT CSV, HEADER);

\echo 'Carregando Empregado...'
\copy Empregado FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tempregado.csv' WITH (FORMAT CSV, HEADER);

\echo 'Carregando Vendedor...'
\copy Vendedor FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tvendedor.csv' WITH (FORMAT CSV, HEADER);

\echo 'Carregando Cliente...'
\copy Cliente FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tcliente.csv' WITH (FORMAT CSV, HEADER);

-- 4. Tabela que depende de Pessoa e Departamento
\echo 'Carregando HistoricoDepartamento...'
\copy HistoricoDepartamento FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/thistoricodepartamento.csv' WITH (FORMAT CSV, HEADER);

-- 5. Tabela que depende de Subcategoria
\echo 'Carregando Produto...'
\copy Produto FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tproduto.csv' WITH (FORMAT CSV, HEADER);

-- 6. Tabela que depende de Cliente e Vendedor(Pessoa)
\echo 'Carregando Venda...'
\copy Venda FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/tvenda.csv' WITH (FORMAT CSV, HEADER);

-- 7. Tabela que depende de Venda e Produto
\echo 'Carregando ItemVenda...'
\copy ItemVenda FROM '/home/leonardocampos/Documentos/Leonardo/lab-bd-pae/titemvenda.csv' WITH (FORMAT CSV, HEADER);

\echo 'Importação de dados concluída!'





-- =================================================================
-- SCRIPT DE ESTATÍSTICAS E VERIFICAÇÃO DE DADOS
-- Este script verifica a integridade dos dados importados.
-- =================================================================

-- PARTE 1: CONTAGEM TOTAL DE REGISTROS POR TABELA

SELECT '1. Categoria' AS tabela, COUNT(*) AS total_registros FROM Categoria
UNION ALL
SELECT '2. Subcategoria' AS tabela, COUNT(*) FROM Subcategoria
UNION ALL
SELECT '3. Departamento' AS tabela, COUNT(*) FROM Departamento
UNION ALL
SELECT '4. Endereco' AS tabela, COUNT(*) FROM Endereco
UNION ALL
SELECT '5. Pessoa' AS tabela, COUNT(*) FROM Pessoa
UNION ALL
SELECT '6. Cliente' AS tabela, COUNT(*) FROM Cliente
UNION ALL
SELECT '7. Empregado' AS tabela, COUNT(*) FROM Empregado
UNION ALL
SELECT '8. HistoricoDepartamento' AS tabela, COUNT(*) FROM HistoricoDepartamento
UNION ALL
SELECT '9. Produto' AS tabela, COUNT(*) FROM Produto
UNION ALL
SELECT '10. Telefone' AS tabela, COUNT(*) FROM Telefone
UNION ALL
SELECT '11. Vendedor' AS tabela, COUNT(*) FROM Vendedor
UNION ALL
SELECT '12. Venda' AS tabela, COUNT(*) FROM Venda
UNION ALL
SELECT '13. ItemVenda' AS tabela, COUNT(*) FROM ItemVenda
ORDER BY tabela;





-- PARTE 2: CARDINALIDADE DE ATRIBUTOS PRINCIPAIS
-- Verifica a quantidade de valores distintos em colunas importantes para
-- garantir a unicidade onde ela é esperada.




SELECT
    COUNT(DISTINCT id_pessoa) AS pessoas_unicas,
    COUNT(DISTINCT email) AS emails_unicos
FROM Pessoa;

SELECT
    COUNT(*) AS total_empregados,
    COUNT(DISTINCT documento) AS documentos_unicos
FROM Empregado;



SELECT
    COUNT(*) AS total_produtos,
    COUNT(DISTINCT numero_produto) AS numeros_de_produto_unicos,
    COUNT(DISTINCT nome) AS nomes_de_produto_unicos
FROM Produto;

SELECT
    COUNT(*) AS total_clientes,
    COUNT(DISTINCT id_cliente) AS ids_de_cliente_unicos
FROM Cliente;


-- PARTE 3: VERIFICAÇÃO DE VALORES NULOS
-- Conta quantos registros possuem valores nulos (vazios) em colunas importantes
-- que não são obrigatórias (não possuem restrição NOT NULL).

-- 1) Verifica vendas sem vendedor e sem código de aprovação do cartão
-- 2) Verifica produtos com informações opcionais faltando
-- 3) Verifica o histórico de departamento para registros que não têm data de saída (funcionários atuais)





SELECT
    COUNT(*) FILTER (WHERE id_vendedor IS NULL) AS vendas_sem_vendedor,
    COUNT(*) FILTER (WHERE codigo_aprovacao_cartao IS NULL) AS vendas_sem_cod_aprovacao
FROM Venda;


SELECT
    COUNT(*) FILTER (WHERE cor IS NULL) AS produtos_sem_cor,
    COUNT(*) FILTER (WHERE tamanho IS NULL) AS produtos_sem_tamanho,
    COUNT(*) FILTER (WHERE peso IS NULL) AS produtos_sem_peso,
    COUNT(*) FILTER (WHERE modelo IS NULL) AS produtos_sem_modelo
FROM Produto;


SELECT COUNT(*) AS funcionarios_ativos_no_depto FROM HistoricoDepartamento WHERE data_saida IS NULL;


SELECT DISTINCT cidade FROM Endereco ORDER BY cidade;


SELECT
    p.nome,
    p.email,
    e.cidade,
    e.estado,
    e.pais
FROM
    Cliente AS c
JOIN
    Pessoa AS p ON c.id_pessoa = p.id_pessoa
JOIN
    Endereco AS e ON p.id_endereco = e.id_endereco
WHERE
    e.cidade = 'Albany'
ORDER BY
    p.nome; 

	