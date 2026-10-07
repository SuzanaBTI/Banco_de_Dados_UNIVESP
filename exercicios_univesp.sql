-- =========================================================================
-- UNIVERSIDADE VIRTUAL DO ESTADO DE SÃO PAULO - UNIVESP
-- DISCIPLINA: BANCO DE DADOS
-- COMPLEMENTO DE EXERCÍCIOS PRÁTICOS (RESOLUÇÃO DOS CENÁRIOS 2 E 3)
-- =========================================================================

-- =========================================================================
-- PARTE 1: ADICIONANDO AS TABELAS DO EXERCÍCIO 2 (AUTORES E ARTIGOS)
-- =========================================================================

-- Criação da tabela Autor (Entidade Forte)
CREATE TABLE autor (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    titulo_academico VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- Criação da tabela Artigo Científico (Relacionamento 1:N com Evento Acadêmico)
-- O id_evento atua como FK e possui restrição NOT NULL para evitar registros órfãos
CREATE TABLE artigo_cientifico (
    id_artigo INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(250) NOT NULL,
    palavras_chave VARCHAR(200) NOT NULL,
    id_evento INT NOT NULL,
    FOREIGN KEY (id_evento) REFERENCES evento_academico(id_evento) ON DELETE RESTRICT
);

-- Tabela intermediária de Autoria (Relacionamento N:M entre Artigo e Autor)
CREATE TABLE artigo_autor (
    id_artigo INT,
    cpf_autor VARCHAR(11),
    PRIMARY KEY (id_artigo, cpf_autor),
    FOREIGN KEY (id_artigo) REFERENCES artigo_cientifico(id_artigo) ON DELETE CASCADE,
    FOREIGN KEY (cpf_autor) REFERENCES autor(cpf) ON DELETE CASCADE
);

-- =========================================================================
-- PARTE 2: ADICIONANDO AS TABELAS DO EXERCÍCIO 3 (INFRAESTRUTURA E RESERVAS)
-- =========================================================================

-- Criação da tabela Predio (Entidade Forte com Endereço Desmembrado/Composto)
CREATE TABLE predio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL
);

-- Criação da tabela Sala (Entidade Fraca)
-- A Chave Primária é composta: junta a PK do Prédio + o número da sala
CREATE TABLE sala (
    id_predio INT,
    numero INT,
    valor DECIMAL(10, 2) NOT NULL,
    qtde_cadeiras INT NOT NULL,
    recursos TEXT, -- Atributo multivalorado armazenado de forma textual/linear
    PRIMARY KEY (id_predio, numero),
    FOREIGN KEY (id_predio) REFERENCES predio(id) ON DELETE CASCADE
);

-- Tabela do relacionamento com atributos: Reserva (N:M entre Evento e Sala)
-- Registra obrigatoriamente os metadados de controle temporal: data_inicio e data_fim
CREATE TABLE reserva (
    id_evento INT,
    id_predio INT,
    numero_sala INT,
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP NOT NULL,
    PRIMARY KEY (id_evento, id_predio, numero_sala, data_inicio),
    FOREIGN KEY (id_evento) REFERENCES evento_academico(id_evento) ON DELETE CASCADE,
    FOREIGN KEY (id_predio, numero_sala) REFERENCES sala(id_predio, numero) ON DELETE CASCADE
);

-- =========================================================================
-- PARTE 3: POPULANDO O BANCO DE DADOS (OPERADORES DML)
-- =========================================================================

-- Inserindo Autores
INSERT INTO autor (cpf, nome, titulo_academico, email) VALUES 
('11122233344', 'Carlos Silva', 'Doutor', 'carlos.silva@univesp.br'),
('55566677788', 'Ana Santos', 'Mestre', 'ana.santos@univesp.br');

-- Inserindo Artigos Associados ao Evento criado anteriormente (ID: 1)
INSERT INTO artigo_cientifico (titulo, palavras_chave, id_evento) VALUES 
('Otimização de Performance com Índices SQL', 'SQL, Performance, Index', 1),
('Análise de Pipelines de Agregação no MongoDB', 'NoSQL, MongoDB, Big Data', 1);

-- Vinculando Autores aos Artigos (Relacionamento N:M)
INSERT INTO artigo_autor (id_artigo, cpf_autor) VALUES 
(1, '11122233344'),
(2, '11122233344'),
(2, '55566677788');

-- Inserindo Infraestrutura Física (Prédios e Salas)
INSERT INTO predio (rua, numero, cidade, estado) VALUES 
('Av. Universitária', '1000', 'São Paulo', 'SP');

INSERT INTO sala (id_predio, numero, valor, qtde_cadeiras, recursos) VALUES 
(1, 101, 150.00, 45, 'Projetor, Ar-Condicionado'),
(1, 102, 200.00, 60, 'Projetor, Caixa de Som, Computador');

-- Efetuando Reservas para o Evento Acadêmico
INSERT INTO reserva (id_evento, id_predio, numero_sala, data_inicio, data_fim) VALUES 
(1, 1, 101, '2026-10-15 08:00:00', '2026-10-15 12:00:00'),
(1, 1, 102, '2026-10-15 14:00:00', '2026-10-15 18:00:00');

-- =========================================================================
-- PARTE 4: CONSULTAS ANALÍTICAS AVANÇADAS (DQL - MULTIPLOS JOINS)
-- =========================================================================

-- Consulta 1: Listagem completa de publicações por evento acadêmico
SELECT 
    e.sigla AS Evento,
    ac.titulo AS Titulo_Artigo,
    GROUP_CONCAT(a.nome SEPARATOR ', ') AS Autores
FROM artigo_cientifico ac
INNER JOIN evento_academico e ON ac.id_evento = e.id_evento
INNER JOIN artigo_autor aa ON ac.id_artigo = aa.id_artigo
INNER JOIN autor a ON aa.cpf_autor = a.cpf
GROUP BY ac.id_artigo, e.sigla
ORDER BY e.sigla;

-- Consulta 2: Relatório de faturamento e ocupação física de salas por evento
SELECT 
    e.nome AS Nome_Evento,
    CONCAT('Prédio ', p.id, ' - Sala ', s.numero) AS Localizacao_Fisica,
    r.data_inicio AS Inicio_Reserva,
    r.data_fim AS Fim_Reserva,
    s.valor AS Custo_Locacao
FROM reserva r
LEFT JOIN evento_academico e ON r.id_evento = e.id_evento
LEFT JOIN sala s ON (r.id_predio = s.id_predio AND r.numero_sala = s.numero)
LEFT JOIN predio p ON s.id_predio = p.id
WHERE s.qtde_cadeiras >= 40
ORDER BY r.data_inicio ASC;

-- =========================================================================
-- PARTE 5: VIEWS (TABELAS VIRTUAIS PARA SEGURANÇA E PERFORMANCE)
-- =========================================================================

CREATE VIEW v_resumo_autores_ti AS
SELECT 
    nome, 
    titulo_academico, 
    email 
FROM autor 
WHERE titulo_academico IN ('Mestre', 'Doutor');
