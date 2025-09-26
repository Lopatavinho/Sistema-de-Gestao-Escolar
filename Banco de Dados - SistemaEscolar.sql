CREATE DATABASE SistemaEscolar;
USE SistemaEscolar;

CREATE TABLE Pessoa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Cliente (
    id INT PRIMARY KEY,
    endereco VARCHAR(200),
    CONSTRAINT fk_cliente_pessoa FOREIGN KEY (id) REFERENCES Pessoa(id)
);

CREATE TABLE Fornecedor (
    id INT PRIMARY KEY,
    empresa VARCHAR(100),
    CONSTRAINT fk_fornecedor_pessoa FOREIGN KEY (id) REFERENCES Pessoa(id)
);

CREATE TABLE Empregado (
    id INT PRIMARY KEY,
    cargo VARCHAR(50),
    salario DECIMAL(10,2),
    CONSTRAINT fk_empregado_pessoa FOREIGN KEY (id) REFERENCES Pessoa(id)
);

CREATE TABLE Vendedor (
    id INT PRIMARY KEY,
    comissao DECIMAL(5,2),
    CONSTRAINT fk_vendedor_empregado FOREIGN KEY (id) REFERENCES Empregado(id)
);

CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    pessoa_id INT NOT NULL,
    CONSTRAINT fk_usuario_pessoa FOREIGN KEY (pessoa_id) REFERENCES Pessoa(id)
);

CREATE TABLE Produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10,2) NOT NULL,
    estoque INT DEFAULT 0
);

CREATE TABLE Pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    vendedor_id INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES Cliente(id),
    CONSTRAINT fk_pedido_vendedor FOREIGN KEY (vendedor_id) REFERENCES Vendedor(id)
);

CREATE TABLE ItemPedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_itempedido_pedido FOREIGN KEY (pedido_id) REFERENCES Pedido(id),
    CONSTRAINT fk_itempedido_produto FOREIGN KEY (produto_id) REFERENCES Produto(id)
);

-- Pessoa
INSERT INTO Pessoa (nome, cpf, email, telefone) VALUES ('João Silva', '123.456.789-00', 'joao@email.com', '11999999999');

-- Cliente
INSERT INTO Cliente (id, endereco) VALUES (1, 'Rua Exemplo, 123');

-- Produto
INSERT INTO Produto (nome, descricao, preco, estoque) VALUES ('Mouse Gamer', 'Mouse RGB', 150.00, 20);

-- Pedido
INSERT INTO Pedido (cliente_id, vendedor_id, total) VALUES (1, NULL, 150.00);

-- ItemPedido
INSERT INTO ItemPedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES (1, 1, 1, 150.00);

-- Ver todos os clientes
SELECT * FROM Cliente;

-- Ver pedidos de um cliente
SELECT * FROM Pedido WHERE cliente_id = 1;

-- Itens de um pedido
SELECT p.nome, ip.quantidade, ip.preco_unitario
FROM ItemPedido ip
JOIN Produto p ON ip.produto_id = p.id
WHERE ip.pedido_id = 1;
