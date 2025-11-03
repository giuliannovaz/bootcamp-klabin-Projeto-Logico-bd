# Desafio de Projeto: Modelagem de Banco de Dados para E-commerce

Este repositório contém o projeto lógico de banco de dados para um cenário de e-commerce, desenvolvido como parte de um desafio de bootcamp. O modelo aborda refinamentos importantes como a herança para clientes (Pessoa Física e Jurídica) e o registro de múltiplas formas de pagamento e detalhes de rastreio de entrega.

## Modelo Lógico Aplicado

O modelo relacional foi mapeado a partir de um Modelo Entidade-Relacionamento Estendido (EER), aplicando a estratégia de **Uma Tabela por Superclasse e uma Tabela por Subclasse** para a herança de Clientes (PJ/PF).

### Refinamentos e Mapeamento Específico:

1.  **Cliente PJ e PF:** A entidade `CLIENTE` é a superclasse, com as subclasses `CLIENTE_PF` e `CLIENTE_PJ`. Ambas as subclasses possuem chave primária (`idPF` / `idPJ`) que é também uma chave estrangeira referenciando o `idClient` da superclasse, garantindo a exclusividade (Disjunção) e a totalidade (todo `CLIENTE` é PF ou PJ).
2.  **Pagamento:** A relação N:M entre `CLIENTE` e `PAGAMENTO` foi implementada através da tabela `PAGAMENTO_CLIENTE`, permitindo que um cliente cadastre múltiplas formas de pagamento. Além disso, a tabela `PAGAMENTO` armazena os detalhes de pagamento vinculados a um `PEDIDO`.
3.  **Entrega:** A entidade `ENTREGA` é dependente de `PEDIDO` (Entidade Fraca) e possui os campos `StatusEntrega` e `CodigoRastreio` (UNIQUE).

## Estrutura do Repositório

* `schema_creation.sql`: Script SQL para a criação de todas as tabelas e constraints.
* `data_persistence.sql`: Script SQL contendo os comandos `INSERT` para popular o banco de dados.
* `complex_queries.sql`: Script SQL contendo as consultas complexas com `SELECT`, `WHERE`, atributos derivados, `ORDER BY`, `HAVING` e `JOIN`.
