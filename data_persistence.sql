USE ecommerce;

-- Inserção de Clientes (Superclasse)
INSERT INTO CLIENTE (idClient, Endereco, CPF_ou_CNPJ) VALUES 
(1, 'Rua A, 100 - Cidade A, SP', '12345678901'),
(2, 'Avenida B, 200 - Cidade B, RJ', '11223344000199'),
(3, 'Travessa C, 300 - Cidade C, MG', '98765432109'),
(4, 'Estrada D, 400 - Cidade D, RS', '55667788000100');

-- Inserção de Clientes PF (Subclasse)
INSERT INTO CLIENTE_PF (idPF, Nome, CPF) VALUES 
(1, 'João da Silva', '12345678901'),
(3, 'Maria Oliveira', '98765432109');

-- Inserção de Clientes PJ (Subclasse)
INSERT INTO CLIENTE_PJ (idPJ, RazaoSocial, CNPJ) VALUES 
(2, 'Tech Solutions LTDA', '11223344000199'),
(4, 'Varejo Online S.A.', '55667788000100');

-- Inserção de Produtos
INSERT INTO PRODUTO (idProduto, NomeProduto, Categoria, Descricao, Valor) VALUES
(1, 'Smartwatch X', 'Eletrônico', 'Relógio inteligente com GPS', 750.00),
(2, 'Camiseta Básica', 'Vestuário', 'Algodão Pima, Cor Preta', 59.90),
(3, 'Sofá Modular 3 Lugares', 'Móveis', 'Tecido Suede, Cinza', 2500.00),
(4, 'Pacote de Café Especial', 'Alimentos', 'Grãos torrados, 500g', 35.50),
(5, 'Fone de Ouvido Bluetooth', 'Eletrônico', 'Cancelamento de ruído', 450.00);

-- Inserção de Pedidos
INSERT INTO PEDIDO (idPedido, StatusPedido, Descricao, Frete, idCliente, DataPedido) VALUES
(1, 'Entregue', 'Pedido de eletrônicos', 15.50, 1, '2025-10-01'),
(2, 'Em processamento', 'Pedido de escritório PJ', 30.00, 2, '2025-10-20'),
(3, 'Enviado', 'Presente de aniversário', 10.00, 3, '2025-10-25'),
(4, 'Cancelado', 'Item indisponível', 0.00, 1, '2025-11-01');

-- Inserção de Produtos no Pedido (PRODUTO_PEDIDO)
INSERT INTO PRODUTO_PEDIDO (idPPedido, idProduto, Quantidade, Status) VALUES
(1, 1, 1, 'Disponível'),
(1, 2, 2, 'Disponível'),
(2, 5, 10, 'Disponível'),
(3, 3, 1, 'Disponível'),
(3, 4, 3, 'Disponível');

-- Inserção de Pagamentos
INSERT INTO PAGAMENTO (idPagamento, TipoPagamento, Valor, Bandeira, idPedido) VALUES
(1, 'Cartão Crédito', 870.90, 'Visa', 1), -- Pagamento 1 (pedido 1)
(2, 'Boleto', 4500.00, NULL, 2),    -- Pagamento 2 (pedido 2)
(3, 'Pix', 2545.50, NULL, 3),      -- Pagamento 3 (pedido 3)
(4, 'Cartão Crédito', 100.00, 'Master', 1); -- Pagamento 4 (pedido 1 - usando mais de uma forma)

-- Inserção de Cadastro de Pagamento por Cliente (PAGAMENTO_CLIENTE)
INSERT INTO PAGAMENTO_CLIENTE (idCliente, idPagamento) VALUES
(1, 1),
(1, 4), -- Cliente 1 tem duas formas cadastradas
(2, 2),
(3, 3);

-- Inserção de Entregas
INSERT INTO ENTREGA (idEntrega, StatusEntrega, CodigoRastreio, DataPrevisao, idPedido) VALUES
(1, 'Entregue', 'BR123456789BR', '2025-10-10', 1),
(2, 'Em Transporte', 'BR987654321BR', '2025-10-30', 3);

-- Inserção de Estoques
INSERT INTO ESTOQUE (idEstoque, Local) VALUES
(1, 'São Paulo - Zona Sul'),
(2, 'Minas Gerais - Belo Horizonte'),
(3, 'Rio de Janeiro - Capital');

-- Inserção de Produtos no Estoque (PRODUTO_EM_ESTOQUE)
INSERT INTO PRODUTO_EM_ESTOQUE (idPEstoque, idPProduto, Quantidade) VALUES
(1, 1, 100), -- Smartwatch em SP
(1, 2, 500), -- Camiseta em SP
(2, 4, 200), -- Café em MG
(3, 5, 1000); -- Fone em RJ

-- Inserção de Fornecedores
INSERT INTO FORNECEDOR (idFornecedor, RazaoSocial, CNPJ) VALUES
(1, 'Global Tech Suprimentos', '90123456000100'),
(2, 'Textil Fio de Ouro', '01020304000100'),
(3, 'Mundo do Café Gourmet', '00112233000144');

-- Inserção de Produtos Fornecidos
INSERT INTO PRODUTO_FORNECEDOR (idPFornedor, idPProduto) VALUES
(1, 1),
(1, 5), -- Global fornece Smartwatch e Fone
(2, 2), -- Textil fornece Camiseta
(3, 4); -- Mundo do Café fornece Café

-- Inserção de Vendedores (Com um que também é fornecedor)
INSERT INTO VENDEDOR (idVendedor, RazaoSocial, NomeFantasia, CNPJ, Local) VALUES
(1, 'Venda Mais Eletrônicos', 'VM Eletro', '60000000000100', 'São Paulo'),
(2, 'Decora Casa e Jardim', 'DecoraCasa', '70000000000100', 'Rio de Janeiro'),
(3, 'Global Tech Suprimentos', 'GlobalTech', '90123456000100', 'São Paulo'); -- Mesmo CNPJ que Fornecedor 1

-- Inserção de Produtos Vendidos pelo Vendedor
INSERT INTO PRODUTO_VENDEDOR (idPVendedor, idProduto, Quantidade, PrecoVenda) VALUES
(1, 1, 50, 800.00),  -- VM Eletro vende Smartwatch
(1, 5, 200, 500.00), -- VM Eletro vende Fone
(2, 3, 10, 2800.00), -- Decora Casa vende Sofá
(3, 1, 10, 780.00);  -- Global Tech (Vendedor) vende Smartwatch
