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

