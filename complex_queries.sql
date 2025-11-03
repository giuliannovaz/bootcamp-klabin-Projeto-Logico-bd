Queries SQL Complexas

Quantos pedidos foram feitos por cada cliente? (GROUP BY + Agregação)
Qual o volume de pedidos realizados por cada cliente, identificando-os pelo nome (PF) ou Razão Social (PJ)?

-- Query 1: Total de Pedidos por Cliente (PF/PJ)
-- Utiliza UNION para unir os nomes de PF e PJ em uma lista única de clientes.
SELECT 
    COALESCE(PF.Nome, PJ.RazaoSocial) AS Nome_Cliente,
    COUNT(P.idPedido) AS Total_Pedidos
FROM 
    PEDIDO P
INNER JOIN 
    CLIENTE C ON P.idCliente = C.idClient
LEFT JOIN 
    CLIENTE_PF PF ON C.idClient = PF.idPF
LEFT JOIN 
    CLIENTE_PJ PJ ON C.idClient = PJ.idPJ
GROUP BY 
    Nome_Cliente
ORDER BY 
    Total_Pedidos DESC;


Algum vendedor também é fornecedor? (Junção + Filtro Simples)
Existe alguma entidade que atua simultaneamente como Vendedor e Fornecedor na plataforma, baseando-se no CNPJ?

-- Query 2: Vendedor que também é Fornecedor
-- Utiliza INNER JOIN entre VENDEDOR e FORNECEDOR na coluna CNPJ.
SELECT 
    V.RazaoSocial AS Nome_Vendedor,
    F.RazaoSocial AS Nome_Fornecedor,
    V.CNPJ
FROM 
    VENDEDOR V
INNER JOIN 
    FORNECEDOR F ON V.CNPJ = F.CNPJ;

Relação de produtos, fornecedores e estoques. (Junção Múltipla)
Para cada produto em estoque, quais fornecedores o fornecem e em qual localização de estoque ele se encontra?

-- Query 3: Produtos, Fornecedores e Estoques
-- Junção de 4 tabelas (PRODUTO, PRODUTO_EM_ESTOQUE, ESTOQUE, PRODUTO_FORNECEDOR, FORNECEDOR)
SELECT 
    P.NomeProduto,
    F.RazaoSocial AS Nome_Fornecedor,
    E.Local AS Local_Estoque,
    PE.Quantidade AS Quantidade_Em_Estoque
FROM 
    PRODUTO P
INNER JOIN 
    PRODUTO_FORNECEDOR PF ON P.idProduto = PF.idPProduto
INNER JOIN 
    FORNECEDOR F ON PF.idPFornedor = F.idFornecedor
INNER JOIN 
    PRODUTO_EM_ESTOQUE PE ON P.idProduto = PE.idPProduto
INNER JOIN 
    ESTOQUE E ON PE.idPEstoque = E.idEstoque
ORDER BY 
    P.NomeProduto, Local_Estoque;


Pedidos com Frete Alto e Atributo Derivado (HAVING + Expressão Derivada + Ordenação)
Quais pedidos, já entregues ou enviados, tiveram um valor total (produtos + frete) superior a R$ 1000,00 e qual foi este valor total?


-- Query 4: Pedidos com Frete Alto e Atributo Derivado
SELECT 
    P.idPedido,
    P.DataPedido,
    P.StatusPedido,
    P.Frete,
    -- Expressão para gerar atributo derivado: Valor_Total_Pedido
    SUM(PP.Quantidade * Prod.Valor) AS Valor_Produtos,
    (SUM(PP.Quantidade * Prod.Valor) + P.Frete) AS Valor_Total_Pedido -- Atributo Derivado
FROM 
    PEDIDO P
INNER JOIN 
    PRODUTO_PEDIDO PP ON P.idPedido = PP.idPPedido
INNER JOIN 
    PRODUTO Prod ON PP.idProduto = Prod.idProduto
WHERE 
    P.StatusPedido IN ('Entregue', 'Enviado') -- Filtro com WHERE Statement
GROUP BY 
    P.idPedido, P.DataPedido, P.StatusPedido, P.Frete
HAVING 
    Valor_Total_Pedido > 1000.00 -- Condição de filtros aos grupos – HAVING Statement
ORDER BY 
    Valor_Total_Pedido DESC; -- Ordenação dos dados com ORDER BY


Relação de Nomes dos Fornecedores e Nomes dos Produtos (SELECT Simples + Junção)
Qual a lista de produtos fornecidos por cada Razão Social de Fornecedor?

-- Query 5: Relação Fornecedor e Produto
SELECT 
    F.RazaoSocial AS Nome_Fornecedor,
    P.NomeProduto,
    P.Valor AS Preco_Sugerido -- Recuperação simples com SELECT Statement
FROM 
    FORNECEDOR F
INNER JOIN 
    PRODUTO_FORNECEDOR PF ON F.idFornecedor = PF.idPFornedor -- Crie junções entre tabelas
INNER JOIN 
    PRODUTO P ON PF.idPProduto = P.idProduto
ORDER BY 
    Nome_Fornecedor, Nome_Produto;
