-- Elaboração queries SQL
--
-- Considerando um banco de dados MySQL ou PostgreSQL que contém uma tabela
-- chamada "produto" (com os campos "id", "nome" e "valor") e outra tabela
-- denominada "vendas" (com os campos "id", "data", "produto_id" e "qtde"),
-- é necessário elaborar uma consulta SQL. Esta consulta deve ser capaz de
-- retornar as vendas mensais de cada produto, especificando o mês, o produto,
-- a quantidade vendida e o valor total dessas vendas.

DROP TABLE IF EXISTS vendas;
DROP TABLE IF EXISTS produtos;

CREATE TABLE produtos
(
    id    INTEGER PRIMARY KEY,
    nome  VARCHAR(100)   NOT NULL,
    valor NUMERIC(10, 2) NOT NULL
);

CREATE TABLE vendas
(
    id         INTEGER PRIMARY KEY,
    data       DATE    NOT NULL,
    quantidade INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    FOREIGN KEY (produto_id)
        REFERENCES produtos (id)
);

INSERT INTO produtos (id, nome, valor)
VALUES (1, 'Livro', 54.55),
       (2, 'Caderno', 21.25),
       (3, 'Pasta', 44.5),
       (4, 'Mesa', 90.15),
       (5, 'Caneta', 4.9);

INSERT INTO vendas (id, data, quantidade, produto_id)
VALUES (1, '2019-11-14', 3, 1),
       (2, '2020-02-01', 1, 1),
       (3, '2020-02-04', 4, 1),
       (4, '2021-03-02', 1, 4),
       (5, '2021-05-06', 1, 2),
       (6, '2021-12-02', 2, 3),
       (7, '2022-01-14', 2, 2),
       (8, '2022-01-14', 2, 5),
       (9, '2022-01-14', 1, 5),
       (10, '2022-01-14', 10, 5),
       (11, '2022-02-14', 3, 5),
       (12, '2022-02-21', 1, 5),
       (13, '2022-02-22', 2, 4);


-- Meses sem venda são ignorados
SELECT date_part('year', data)                     AS ano,
       to_char(date_trunc('month', data), 'Month') as mes,
       nome                                        AS produto,
       SUM(quantidade)                             AS qtd_total,
       SUM(valor * quantidade)                     AS valor_total
FROM vendas
         INNER JOIN produtos on produtos.id = vendas.produto_id
GROUP BY ano, date_trunc('month', data), nome
ORDER BY ano, date_trunc('month', data), nome;


-- Output:
--
--  ano  |    mes    | produto | qtd_total | valor_total
-- ------+-----------+---------+-----------+-------------
--  2019 | November  | Livro   |         3 |      163.65
--  2020 | February  | Livro   |         5 |      272.75
--  2021 | March     | Mesa    |         1 |       90.15
--  2021 | May       | Caderno |         1 |       21.25
--  2021 | December  | Pasta   |         2 |       89.00
--  2022 | January   | Caderno |         2 |       42.50
--  2022 | January   | Caneta  |        13 |       63.70
--  2022 | February  | Caneta  |         4 |       19.60
--  2022 | February  | Mesa    |         2 |      180.30
