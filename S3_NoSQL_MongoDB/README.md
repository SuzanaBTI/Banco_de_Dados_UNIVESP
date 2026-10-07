# 🍃 Módulo 3: Banco de Dados NoSQL com MongoDB

Este diretório armazena os conceitos práticos, estruturas de documentos e pipelines de agregação desenvolvidos no **MongoDB Atlas** durante o estudo de bancos de dados não-relacionais orientados a documentos (Semanas 7 e 8 da UNIVESP).

## 🔄 Mapeamento de Conceitos (SQL vs NoSQL)

| Banco Relacional (SQL) | NoSQL MongoDB |
| :--- | :--- |
| Banco de Dados | Banco de Dados |
| Tabela | Coleção (*Collection*) |
| Linha / Registro | Documento (*Document*) |
| Coluna | Campo (*Field*) |

## 🛠️ Prática: Pipeline de Agregação (*Aggregation Framework*)

Utilizando um banco de dados real hospedado na nuvem do **MongoDB Atlas v8.0**, populamos a coleção `eventos` com os dados integrados do minimundo. 

Para extrair um relatório contendo apenas eventos com **mais de 20 artigos**, ocultando IDs e exibindo exclusivamente os campos essenciais, implementamos um pipeline composto por dois estágios (*Stages*):

### Estágio 1: Filtro (`$match`)
Equivale ao `WHERE` do SQL. Filtra usando o operador `$gt` (*Greater Than* - Maior que).
```json
{
  "artigos_recebidos": { "$gt": 20 }
}
```

### Estágio 2: Seleção de Campos (`$project`)
Equivale ao `SELECT` do SQL. Define a exibição (`1`) ou ocultação (`0`) dos campos.
```json
{
  "nome": 1,
  "sigla": 1,
  "artigos_recebidos": 1,
  "_id": 0
}
```

### 📋 Resultado do Preview no Atlas:
```json
{
  "nome": "Simpósio de IA",
  "sigla": "SIA",
  "artigos_recebidos": 45
}
```
