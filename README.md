# 🗄️ Banco de Dados - UNIVESP (COM300)

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

Repositório dedicado ao armazenamento de exercícios, desafios e projetos práticos desenvolvidos durante a disciplina de Banco de Dados da UNIVESP (Universidade Virtual do Estado de São Paulo).

## 🚀 Estrutura do Repositório

O conteúdo está dividido em módulos cronológicos que acompanham a ementa da disciplina:

### 📐 [Módulo 1: Modelo Conceitual](./S1_Modelo_Conceitual)
* **Foco:** Levantamento de requisitos, minimundos e mapeamento de regras de negócio.
* **Prática:** Criação de Diagramas Entidade-Relacionamento (DER) utilizando sintaxe descritiva `Mermaid.js` diretamente na documentação.
* **Exercícios:** Modelagem do cenário de Universidades e Eventos Acadêmicos.

### 💻 [Módulo 2: Modelo Relacional](./S2_Modelo_Relacional)
* **Foco:** Mapeamento lógico, chaves primárias compostas, chaves estrangeiras e integridade referencial.
* **Prática:** Scripts estruturados em **MySQL 8.0** executados no ambiente online DB-Fiddle (comandos DDL e DML).
* **Exercícios:** Implementação dos módulos de Submissão de Artigos/Autores e Gestão de Infraestrutura/Reservas de Salas utilizando múltiplos cruzamentos (`INNER JOIN`).

### 🍃 [Módulo 3: NoSQL com MongoDB](./S3_NoSQL_MongoDB)
* **Foco:** Bancos de dados não-relacionais orientados a documentos, flexibilidade de esquemas e escalabilidade.
* **Prática:** Modelagem de documentos JSON e execução de esteiras de processamento via **Aggregation Framework** na nuvem pública do **MongoDB Atlas v8.0**.
* **Exercícios:** Criação de pipelines de filtragem (`$match`) e projeção de campos específicos (`$project`).

---

## 🛠️ Tecnologias e Ferramentas Utilizadas
* **SQL:** MySQL 8.0 & DB-Fiddle
* **NoSQL:** MongoDB v8.0 & MongoDB Atlas Cloud
* **Documentação:** Markdown & Mermaid.js

## 💻 Ambientes de Desenvolvimento e Infraestrutura

Para a realização dos projetos e testes práticos desta disciplina, foram exploradas e configuradas duas abordagens de infraestrutura de banco de dados:

1. **Ambiente Virtualizado Local (Linux/Ubuntu):**
   * Configuração e provisionamento de Máquina Virtual (VM) utilizando o hipervisor **Oracle VirtualBox**.
   * Importação e gerenciamento de imagem de appliance (`.ova`) executando sistema operacional **Ubuntu 64-bit** pré-configurado com **MySQL Server** e **MySQL Workbench**.
   * Domínio sobre conceitos de alocação de recursos de hardware (memória RAM, CPU e armazenamento virtualizado) e interfaces de rede para servidores locais.

2. **Ambiente em Nuvem (Cloud/DBaaS):**
   * Migração de escopo para desenvolvimento ágil utilizando **DB-Fiddle** (MySQL 8.0) e implantação de um cluster ativo e escalável no **MongoDB Atlas Cloud** para o gerenciamento de coleções NoSQL.
