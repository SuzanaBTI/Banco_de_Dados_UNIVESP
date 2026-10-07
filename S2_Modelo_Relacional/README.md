# 📄 Exercício 2: Módulo de Submissão e Vínculo de Artigos

Este módulo trata do fluxo de submissão de artigos científicos vinculados a eventos específicos e o gerenciamento de seus respectivos coautores, aplicando regras estritas de integridade relacional.

## 🔍 Consulta Prática (Relatório de Autoria por Artigo)
Para rastrear quais autores escreveram quais artigos e para qual evento eles foram destinados, utilizamos múltiplos cruzamentos de tabelas (`INNER JOIN`):

```sql
SELECT 
    art.titulo AS Titulo_Artigo,
    aut.nome AS Nome_Autor,
    aut.titulo_academico AS Titulacao,
    e.sigla AS Evento_Destino
FROM artigo_autor aa
INNER JOIN artigo_cientifico art ON aa.id_artigo = art.id_artigo
INNER JOIN autor aut ON aa.cpf_autor = aut.cpf
INNER JOIN evento_academico e ON art.id_evento = e.id_evento
ORDER BY art.titulo ASC;
```

### 📋 Resultado da Execução:

| Titulo_Artigo | Nome_Autor | Titulacao | Evento_Destino |
| :--- | :--- | :--- | :--- |
| Abordagens Modernas em Bancos NoSQL | Carlos Eduardo | Doutor | CBD |
| Abordagens Modernas em Bancos NoSQL | Ana Maria Souza | Mestre | CBD |
| Otimização de Índices no MySQL 8 | Carlos Eduardo | Doutor | CBD |

# 📅 Exercício 3: Módulo de Infraestrutura e Reservas

Este módulo trata do mapeamento lógico e implementação em banco de dados relacional para o gerenciamento de prédios, salas e reservas de eventos acadêmicos.

## 🛠️ Tecnologias Utilizadas
* **MySQL 8.0**
* **DB-Fiddle** (Ambiente de Execução Online)

## 📊 Estrutura do Banco de Dados
O script completo de criação das tabelas e inserção de dados de teste pode ser encontrado no arquivo `exercicio_3_reservas.sql`.

## 🔍 Consulta Prática (Relatório de Reservas)
Para extrair quais eventos reservaram quais salas e os seus respectivos horários, utilizamos a seguinte consulta com `INNER JOIN`:

```sql
SELECT 
    e.sigla AS Evento,
    p.rua AS Local_Predio,
    r.numero_sala AS Sala,
    r.data_inicio AS Inicio,
    r.data_fim AS Termino
FROM reserva r
INNER JOIN evento_academico e ON r.id_evento = e.id_evento
INNER JOIN predio p ON r.id_predio = p.id;
```

### 📋 Resultado da Execução:

| Evento | Local_Predio | Sala | Inicio | Termino |
| :--- | :--- | :--- | :--- | :--- |
| SIA | Av. Paulista | 101 | 2026-10-15 08:00:00 | 2026-10-15 12:00:00 |
| CR | Av. Paulista | 102 | 2026-10-15 14:00:00 | 2026-10-15 18:00:00 |

