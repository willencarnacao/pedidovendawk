
-- WKTech - Dump inicial do banco de dados
DROP DATABASE IF EXISTS wktech;
CREATE DATABASE wktech CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE wktech;

-- Tabela de Clientes
CREATE TABLE Clientes (
  Codigo INT PRIMARY KEY,
  Nome VARCHAR(120) NOT NULL,
  Cidade VARCHAR(80) NOT NULL,
  UF CHAR(2) NOT NULL
);

-- Tabela de Produtos
CREATE TABLE Produtos (
  Codigo INT PRIMARY KEY,
  Descricao VARCHAR(150) NOT NULL,
  PrecoVenda DECIMAL(12,2) NOT NULL
);

-- Tabela de Pedidos (dados gerais)
CREATE TABLE Pedidos (
  NumeroPedido INT PRIMARY KEY AUTO_INCREMENT,
  DataEmissao DATETIME NOT NULL,
  CodigoCliente INT NOT NULL,
  ValorTotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  CONSTRAINT fk_pedidos_clientes FOREIGN KEY (CodigoCliente) REFERENCES Clientes(Codigo)
);

-- Tabela de Produtos do Pedido
CREATE TABLE PedidoProdutos (
  ID BIGINT PRIMARY KEY AUTO_INCREMENT,
  NumeroPedido INT NOT NULL,
  CodigoProduto INT NOT NULL,
  Quantidade DECIMAL(12,3) NOT NULL,
  ValorUnitario DECIMAL(12,2) NOT NULL,
  ValorTotal DECIMAL(12,2) NOT NULL,
  CONSTRAINT fk_pedidoprodutos_pedidos FOREIGN KEY (NumeroPedido) REFERENCES Pedidos(NumeroPedido) ON DELETE CASCADE,
  CONSTRAINT fk_pedidoprodutos_produtos FOREIGN KEY (CodigoProduto) REFERENCES Produtos(Codigo)
);

-- Índices
CREATE INDEX ix_pedidos_cliente ON Pedidos(CodigoCliente);
CREATE INDEX ix_pedidoprodutos_pedido ON PedidoProdutos(NumeroPedido);
CREATE INDEX ix_pedidoprodutos_produto ON PedidoProdutos(CodigoProduto);

-- Dados de Clientes (>=20)
INSERT INTO Clientes (Codigo, Nome, Cidade, UF) VALUES
(1, 'Mercado São João', 'Florianópolis', 'SC'),
(2, 'Padaria Central', 'São Paulo', 'SP'),
(3, 'Empório Sul', 'Porto Alegre', 'RS'),
(4, 'Distribuidora Norte', 'Manaus', 'AM'),
(5, 'Lanchonete da Praia', 'Rio de Janeiro', 'RJ'),
(6, 'Restaurante Bom Sabor', 'Curitiba', 'PR'),
(7, 'Armazém Mineiro', 'Belo Horizonte', 'MG'),
(8, 'Super Econômico', 'Recife', 'PE'),
(9, 'HortiFruti Primavera', 'Campo Grande', 'MS'),
(10, 'Casa do Pão', 'Salvador', 'BA'),
(11, 'Empório do Norte', 'Belém', 'PA'),
(12, 'Bazar do Centro', 'Fortaleza', 'CE'),
(13, 'Mini Mercado União', 'João Pessoa', 'PB'),
(14, 'Atacadista Sul', 'Canoas', 'RS'),
(15, 'Loja Popular', 'Vitória', 'ES'),
(16, 'Queijos & Vinhos', 'Pelotas', 'RS'),
(17, 'Doceria do Vale', 'Taubaté', 'SP'),
(18, 'Bar & Mercearia', 'Goiânia', 'GO'),
(19, 'Cantina Itália', 'Caxias do Sul', 'RS'),
(20, 'Café do Centro', 'Blumenau', 'SC');

-- Dados de Produtos (>=20)
INSERT INTO Produtos (Codigo, Descricao, PrecoVenda) VALUES
(101, 'Arroz Tipo 1 5kg', 24.90),
(102, 'Feijão Carioca 1kg', 8.50),
(103, 'Açúcar Refinado 1kg', 5.20),
(104, 'Café Torrado 500g', 16.90),
(105, 'Macarrão Espaguete 500g', 4.90),
(106, 'Óleo de Soja 900ml', 7.40),
(107, 'Leite UHT 1L', 4.80),
(108, 'Biscoito Cream Cracker 400g', 6.30),
(109, 'Molho de Tomate 340g', 3.50),
(110, 'Farinha de Trigo 1kg', 5.80),
(111, 'Sal Refinado 1kg', 2.50),
(112, 'Achocolatado 400g', 9.90),
(113, 'Margarina 500g', 7.10),
(114, 'Queijo Mussarela 500g', 22.00),
(115, 'Presunto 500g', 18.50),
(116, 'Suco de Laranja 1L', 6.90),
(117, 'Refrigerante Cola 2L', 9.50),
(118, 'Sabonete 90g', 2.20),
(119, 'Detergente 500ml', 2.90),
(120, 'Papel Higiênico 12un', 19.90);

-- Exemplo de pedido inicial para teste manual (opcional)
-- INSERT INTO Pedidos (DataEmissao, CodigoCliente, ValorTotal) VALUES (NOW(), 1, 0.00);
-- INSERT INTO PedidoProdutos (NumeroPedido, CodigoProduto, Quantidade, ValorUnitario, ValorTotal) VALUES (1, 101, 2.000, 24.90, 49.80);
-- UPDATE Pedidos SET ValorTotal = (SELECT SUM(ValorTotal) FROM PedidoProdutos WHERE NumeroPedido = 1) WHERE NumeroPedido = 1;
