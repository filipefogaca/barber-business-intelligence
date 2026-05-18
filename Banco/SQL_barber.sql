# Criar o Banco de Dados
CREATE SCHEMA IF NOT EXISTS barber;
USE barber;

#Tabela cliente
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    idade INT,
    data_cadastro DATE
);

#tabela funcionario
CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome VARCHAR(100),
    unidade VARCHAR(45),
    cargo VARCHAR(45)
);

#Tabela atendimentos
CREATE TABLE atendimentos (
    id_atendimento INT PRIMARY KEY,
    id_cliente INT,
    id_funcionario INT,
    unidade VARCHAR(45),
    servico VARCHAR(45),
    valor DECIMAL(10,2),
    data DATE,
    forma_pagamento VARCHAR(45),

    CONSTRAINT fk_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT fk_funcionario
        FOREIGN KEY (id_funcionario)
        REFERENCES funcionarios(id_funcionario)
);

#Tabela metas
CREATE TABLE metas (
    id_metas INT AUTO_INCREMENT PRIMARY KEY,
    ano INT,
    mes INT,
    unidade VARCHAR(45),
    meta_mensal INT
);

#importar CSVs
LOAD DATA LOCAL INFILE 'C:/Users/Filipe/Downloads/clientes_limpos.csv'
INTO TABLE clientes
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/Filipe/Downloads/funcionarios_limpos.csv'
INTO TABLE funcionarios
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/Filipe/Downloads/metas_limpos.csv'
INTO TABLE metas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    ano,
    mes,
    unidade,
    meta_mensal
);

LOAD DATA LOCAL INFILE 'C:/Users/Filipe/Downloads/atendimentos_limpos.csv'
INTO TABLE atendimentos
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id_atendimento,
    id_cliente,
    id_funcionario,
    unidade,
    servico,
    valor,
    data,
    forma_pagamento
);

SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM funcionarios;
SELECT COUNT(*) FROM atendimentos;
SELECT COUNT(*) FROM metas;

SELECT * FROM clientes LIMIT 10;
SELECT * FROM funcionarios LIMIT 10;
SELECT * FROM atendimentos LIMIT 10;
SELECT * FROM metas LIMIT 10;

-- Atendimentos + Funcionarios

SELECT
	a.id_atendimento,
    f.nome,
    a.servico,
    a.valor
FROM atendimentos a, funcionarios f
WHERE a.id_funcionario = f.id_funcionario;

-- Atendimentos + Clientes

SELECT
    a.id_atendimento,
    c.nome,
    a.servico,
    a.valor,
    a.data
FROM atendimentos a, clientes c
WHERE a.id_cliente = c.id_cliente;

-- Clientes + Atendimentos + Funcionarios

SELECT
    c.nome AS cliente,
    f.nome AS funcionario,
    a.servico,
    a.valor,
    a.data
FROM clientes c, funcionarios f, atendimentos a
WHERE c.id_cliente = a.id_cliente
AND f.id_funcionario = a.id_funcionario;

-- Total faturado
SELECT SUM(valor) AS faturamento_total FROM atendimentos;

-- Média dos serviços
SELECT AVG(valor) AS media_servicos
FROM atendimentos;

-- Serviço mais caro

SELECT MAX(valor) AS maior_valor
FROM atendimentos;

-- Serviço mais barato

SELECT MIN(valor) AS menor_valor
FROM atendimentos;

SELECT
    f.nome,
    COUNT(*) AS total_atendimentos
FROM funcionarios f, atendimentos a
WHERE f.id_funcionario = a.id_funcionario
GROUP BY f.nome;

-- Faturamento por unidade

SELECT
    unidade,
    SUM(valor) AS faturamento
FROM atendimentos
GROUP BY unidade;

-- Clientes cadastrados por cidade

SELECT
    cidade,
    COUNT(*) AS total_clientes
FROM clientes
GROUP BY cidade;
	
    
-- Formas de pagamento utilizadas

SELECT
    forma_pagamento,
    COUNT(*) AS quantidade
FROM atendimentos
GROUP BY forma_pagamento;

-- Funcionários com mais atendimentos

SELECT
    f.nome,
    COUNT(*) AS total
FROM funcionarios f, atendimentos a
WHERE f.id_funcionario = a.id_funcionario
GROUP BY f.nome
ORDER BY total DESC;

-- Maiores faturamentos

SELECT
    unidade,
    SUM(valor) AS faturamento
FROM atendimentos
GROUP BY unidade
ORDER BY faturamento DESC;

-- Atendimentos acima de 100 reais

SELECT *
FROM atendimentos
WHERE valor > 100;

-- Atendimentos em 2025

SELECT *
FROM atendimentos
WHERE YEAR(data) = 2025;

SELECT
    m.unidade,
    m.mes,
    m.meta_mensal
FROM metas m;

-- Comparar faturamento real com metas

SELECT
	a.unidade,
    m.mes,
    m.ano,
    SUM(a.valor) AS faturamento_real,
    m.meta_mensal
From atendimentos a, metas m
WHERE a.unidade = m.unidade
GROUP BY a.unidade, m.mes, m.ano, m.meta_mensal
ORDER BY a.unidade, m.mes, m.ano;

-- Top 10 clientes que mais gastaram

SELECT
    c.nome,
    SUM(a.valor) AS total_gasto
FROM clientes c, atendimentos a
WHERE c.id_cliente = a.id_cliente
GROUP BY c.nome
ORDER BY total_gasto DESC
LIMIT 10;

-- Funcionário que mais faturou

SELECT
    f.nome,
    SUM(a.valor) AS faturamento
FROM funcionarios f, atendimentos a
WHERE f.id_funcionario = a.id_funcionario
GROUP BY f.nome
ORDER BY faturamento DESC;

-- Serviço mais realizado

SELECT
    servico,
    COUNT(*) AS quantidade
FROM atendimentos
GROUP BY servico
ORDER BY quantidade DESC;

-- Faturamento por mês

SELECT
    MONTH(data) AS mes,
    SUM(valor) AS faturamento
FROM atendimentos
GROUP BY MONTH(data)
ORDER BY mes;










