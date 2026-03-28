DROP DATABASE IF EXISTS atividade_sala;
CREATE DATABASE atividade_sala;
Use atividade_sala;

-- 1. Tabela de Categorias
CREATE TABLE categorias (
    ID_Categoria INT PRIMARY KEY,
    Nome_Categoria VARCHAR(50) NOT NULL
);

-- 2. Tabela de Clientes
CREATE TABLE clientes (
    ID_Cliente INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Cidade VARCHAR(50),
    UF CHAR(2),
    Data_Cadastro DATE
);

-- 3. Tabela de Produtos (Aponta para Categorias)
CREATE TABLE produtos (
    ID_Produto INT PRIMARY KEY,
    Descricao VARCHAR(100) NOT NULL,
    Preco_Unitario DECIMAL(10,2),
    Estoque INT,
    FK_Categoria INT,
    FOREIGN KEY (FK_Categoria) REFERENCES categorias(ID_Categoria)
);

-- 4. Tabela de Vendas (Aponta para Clientes e Produtos)
CREATE TABLE vendas (
    ID_Venda INT PRIMARY KEY,
    FK_Cliente INT,
    FK_Produto INT,
    Quantidade INT,
    Data_Venda DATE,
    FOREIGN KEY (FK_Cliente) REFERENCES clientes(ID_Cliente),
    FOREIGN KEY (FK_Produto) REFERENCES produtos(ID_Produto)
);

-- CATEGORIAS (ID_Categoria, Nome_Categoria)
INSERT INTO categorias VALUES (1, 'Eletrônicos');
INSERT INTO categorias VALUES (2, 'Móveis');
INSERT INTO categorias VALUES (3, 'Informática');


-- CLIENTES (ID_Cliente, Nome, Cidade, UF, Data_Cadastro)
INSERT INTO clientes VALUES (10, 'Ana Silva', 'São Paulo', 'SP', '2023-01-15');
INSERT INTO clientes VALUES (11, 'Bruno Souza', 'Curitiba', 'PR', '2023-05-20');
INSERT INTO clientes VALUES (12, 'Carla Dias', 'São Paulo', 'SP', '2024-02-10');
INSERT INTO clientes VALUES (13, 'Diego Lemos', 'Belo Horizonte', 'MG', '2024-03-01');

-- PRODUTOS (ID_Produto, Descricao, Preco_Unitario, Estoque, FK_Categoria)
INSERT INTO produtos VALUES (101, 'Smartphone X', 2500.00, 50, 1);
INSERT INTO produtos VALUES (102, 'Cadeira Gamer', 1200.00, 15, 2);
INSERT INTO produtos VALUES (103, 'Mouse Sem Fio', 150.00, 100, 3);
INSERT INTO produtos VALUES (104, 'Monitor 4K', 3200.00, 10, 3);
INSERT INTO produtos VALUES (105, 'Mesa de Escritório', 850.00, 8, 2);

-- VENDAS (ID_Venda, FK_Cliente, FK_Produto, Quantidade, Data_Venda)
INSERT INTO vendas VALUES (1001, 10, 101, 1, '2024-03-10');
INSERT INTO vendas VALUES (1002, 11, 102, 2, '2024-03-12');
INSERT INTO vendas VALUES (1003, 10, 103, 5, '2024-03-15');
INSERT INTO vendas VALUES (1004, 12, 101, 1, '2024-03-20');
INSERT INTO vendas VALUES (1005, 13, 105, 1, '2024-03-22');
INSERT INTO vendas VALUES (1006, 10, 104, 1, '2024-03-25');

SELECT * FROM produtos;
SELECT * FROM vendas;
SELECT * FROM categorias;
SELECT * FROM clientes;

--================================================

--Análise de Dados e Agregações.

--================================================

-- A) visão de produtos e preços.

--1. Qual p preço do produto mais caro na categoria 3 (Informática) ?

SELECT MAX (Preco_Unitario) AS Preco_Mais_Caro
FROM produtos 
WHERE FK_Categoria = 3;

--2. Qual o preço do produto mais barato da categoria 2 (Móveis)?

SELECT MIN (Preco_Unitario) AS Preco_Mais_Barato
FROM produtos
WHERE FK_Categoria = 2;

--3. Quantos produtos diferentes temos cadastrados em cada categoria?  

SELECT FK_Categoria, COUNT (*) AS Total_Produtos
FROM produtos
GROUP BY FK_Categoria;

--.B) Visão de Vendas e Clientes.

--1. Filtro por cidade: Qual foi o valor máximo vendido em uma unica unidade para clientes da cidade de São Paulo ?

SELECT MAX(p.Preco_Unitario) AS Maior_Valor_SP
FROM vendas v
JOIN clientes c ON v.FK_Cliente = c.ID_Cliente
JOIN produtos p ON v.FK_Produto = p.ID_Produto
WHERE c.Cidade = 'São Paulo';

-- 2.Soma de Vendas: Qual a quantidade total de itens vendidos para o produto 101?

SELECT SUM(Quantidade) AS Total_Vendido_101 
FROM vendas 
WHERE FK_Produto = 101;

--3. Filtro de Data: Qual o maior valor de produto vendido no período de 15/03/2024 a 25/03/2024?  

SELECT MAX(p.Preco_Unitario) AS Maior_Valor_Periodo
FROM vendas v
JOIN produtos p ON v.FK_Produto = p.ID_Produto
WHERE v.Data_Venda BETWEEN '2024-03-15' AND '2024-03-25';



-- Análise de dados e agregações.    

INSERT INTO vendas VALUES (2000, 99, 101, 1, '2024-04-01'); 

-- Cannot add or update a child row: a foreign key constraint fails (`atividade_sala`.`vendas`, CONSTRAINT `vendas_ibfk_1` FOREIGN KEY (`FK_Cliente`) REFERENCES `clientes` (`ID_Cliente`)) .  

-- Por que o banco de dados deve recusar essa inserção?

--O motivo é simples, mas fundamental na Ciência da Computação: O cliente 99 não existe.

--Na tabela clientes, os IDs cadastrados são 10, 11, 12 e 13. Quando tento criar uma venda para o cliente 99, o banco de dados faz uma checagem instantânea. Se ele permitisse essa venda, eu  teria uma "venda órfã" — um registro de venda que aponta para um cliente fantasma.

-- Qual a relação com o conceito de Chave estrangeira ?


--A relação é de Integridade Referencial. O banco de dados recusa a inserção porque a Chave Estrangeira (FK) funciona como uma regra de consistência: ela impede que a tabela de vendas registre um FK_Cliente que não exista na tabela clientes.

