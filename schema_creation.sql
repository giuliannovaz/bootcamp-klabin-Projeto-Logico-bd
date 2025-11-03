-- Criação do Esquema (Database)
CREATE SCHEMA IF NOT EXISTS ecommerce;
USE ecommerce;

-- -----------------------------------------------------
-- Tabela CLIENTE (Superclasse para Herança PJ/PF)
-- -----------------------------------------------------
CREATE TABLE CLIENTE (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Endereco VARCHAR(255) NOT NULL,
    CPF_ou_CNPJ VARCHAR(18) NOT NULL, -- Coluna para garantir unicidade na superclasse
    CONSTRAINT unique_cpf_cnpj UNIQUE (CPF_ou_CNPJ)
);

-- -----------------------------------------------------
-- Tabela CLIENTE_PF (Subclasse Pessoa Física)
-- -----------------------------------------------------
CREATE TABLE CLIENTE_PF (
    idPF INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    CPF CHAR(11) NOT NULL,
    CONSTRAINT fk_cliente_pf FOREIGN KEY (idPF) REFERENCES CLIENTE (idClient)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT unique_cpf UNIQUE (CPF)
);

-- -----------------------------------------------------
-- Tabela CLIENTE_PJ (Subclasse Pessoa Jurídica)
-- -----------------------------------------------------
CREATE TABLE CLIENTE_PJ (
    idPJ INT PRIMARY KEY,
    RazaoSocial VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    CONSTRAINT fk_cliente_pj FOREIGN KEY (idPJ) REFERENCES CLIENTE (idClient)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT unique_cnpj UNIQUE (CNPJ)
);

-- -----------------------------------------------------
-- Tabela PRODUTO
-- -----------------------------------------------------
CREATE TABLE PRODUTO (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    NomeProduto VARCHAR(255) NOT NULL,
    Categoria ENUM('Eletrônico', 'Vestuário', 'Alimentos', 'Móveis', 'Brinquedos') NOT NULL,
    Descricao VARCHAR(500),
    Valor DECIMAL(10, 2) NOT NULL
);

-- -----------------------------------------------------
-- Tabela PEDIDO
-- -----------------------------------------------------
CREATE TABLE PEDIDO (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    StatusPedido ENUM('Em processamento', 'Em separação', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Em processamento',
    Descricao VARCHAR(255),
    Frete DECIMAL(10, 2) DEFAULT 0,
    idCliente INT NOT NULL,
    DataPedido DATE NOT NULL,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (idCliente) REFERENCES CLIENTE (idClient)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- -----------------------------------------------------
-- Tabela PAGAMENTO
-- -----------------------------------------------------
CREATE TABLE PAGAMENTO (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    TipoPagamento ENUM('Cartão Crédito', 'Boleto', 'Pix', 'Dois Cartões') NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL,
    Bandeira VARCHAR(45) NULL,
    idPedido INT NOT NULL,
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (idPedido) REFERENCES PEDIDO (idPedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- -----------------------------------------------------
-- Tabela PAGAMENTO_CLIENTE (Cadastro de múltiplas formas de pagamento)
-- -----------------------------------------------------
CREATE TABLE PAGAMENTO_CLIENTE (
    idCliente INT,
    idPagamento INT,
    CONSTRAINT pk_pagamento_cliente PRIMARY KEY (idCliente, idPagamento),
    CONSTRAINT fk_pagamento_cliente_cliente FOREIGN KEY (idCliente) REFERENCES CLIENTE (idClient),
    CONSTRAINT fk_pagamento_cliente_pagamento FOREIGN KEY (idPagamento) REFERENCES PAGAMENTO (idPagamento)
);

-- -----------------------------------------------------
-- Tabela ENTREGA (Entidade Fraca dependente de PEDIDO)
-- -----------------------------------------------------
CREATE TABLE ENTREGA (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    StatusEntrega ENUM('Pendente', 'Em Transporte', 'Entregue', 'Atrasado') DEFAULT 'Pendente',
    CodigoRastreio VARCHAR(45) UNIQUE,
    DataPrevisao DATE,
    idPedido INT UNIQUE NOT NULL, -- Relacionamento 1:1 com PEDIDO
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (idPedido) REFERENCES PEDIDO (idPedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Tabela ESTOQUE
-- -----------------------------------------------------
CREATE TABLE ESTOQUE (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    Local VARCHAR(255) NOT NULL
);

-- -----------------------------------------------------
-- Tabela PRODUTO_EM_ESTOQUE (Relacionamento N:M)
-- -----------------------------------------------------
CREATE TABLE PRODUTO_EM_ESTOQUE (
    idPEstoque INT NOT NULL,
    idPProduto INT NOT NULL,
    Quantidade INT DEFAULT 0,
    CONSTRAINT pk_produto_estoque PRIMARY KEY (idPEstoque, idPProduto),
    CONSTRAINT fk_estoque_produto FOREIGN KEY (idPEstoque) REFERENCES ESTOQUE (idEstoque),
    CONSTRAINT fk_produto_estoque_produto FOREIGN KEY (idPProduto) REFERENCES PRODUTO (idProduto)
);

-- -----------------------------------------------------
-- Tabela FORNECEDOR
-- -----------------------------------------------------
CREATE TABLE FORNECEDOR (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    RazaoSocial VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Tabela PRODUTO_FORNECEDOR (Relacionamento N:M)
-- -----------------------------------------------------
CREATE TABLE PRODUTO_FORNECEDOR (
    idPFornedor INT NOT NULL,
    idPProduto INT NOT NULL,
    CONSTRAINT pk_produto_fornecedor PRIMARY KEY (idPFornedor, idPProduto),
    CONSTRAINT fk_fornecedor_produto FOREIGN KEY (idPFornedor) REFERENCES FORNECEDOR (idFornecedor),
    CONSTRAINT fk_produto_fornecedor_produto FOREIGN KEY (idPProduto) REFERENCES PRODUTO (idProduto)
);

-- -----------------------------------------------------
-- Tabela VENDEDOR
-- -----------------------------------------------------
CREATE TABLE VENDEDOR (
    idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    RazaoSocial VARCHAR(255) NOT NULL,
    NomeFantasia VARCHAR(255) NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE,
    Local VARCHAR(255)
);

-- -----------------------------------------------------
-- Tabela PRODUTO_VENDEDOR (Relacionamento N:M)
-- -----------------------------------------------------
CREATE TABLE PRODUTO_VENDEDOR (
    idPVendedor INT NOT NULL,
    idProduto INT NOT NULL,
    Quantidade INT DEFAULT 1,
    PrecoVenda DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_produto_vendedor PRIMARY KEY (idPVendedor, idProduto),
    CONSTRAINT fk_vendedor_produto FOREIGN KEY (idPVendedor) REFERENCES VENDEDOR (idVendedor),
    CONSTRAINT fk_produto_vendedor_produto FOREIGN KEY (idProduto) REFERENCES PRODUTO (idProduto)
);

-- -----------------------------------------------------
-- Tabela PRODUTO_PEDIDO (Relacionamento N:M)
-- -----------------------------------------------------
CREATE TABLE PRODUTO_PEDIDO (
    idPPedido INT NOT NULL,
    idProduto INT NOT NULL,
    Quantidade INT DEFAULT 1,
    Status ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    CONSTRAINT pk_produto_pedido PRIMARY KEY (idPPedido, idProduto),
    CONSTRAINT fk_pedido_produto FOREIGN KEY (idPPedido) REFERENCES PEDIDO (idPedido),
    CONSTRAINT fk_produto_pedido_produto FOREIGN KEY (idProduto) REFERENCES PRODUTO (idProduto)
);
