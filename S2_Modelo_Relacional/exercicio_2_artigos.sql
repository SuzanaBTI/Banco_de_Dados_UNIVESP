sql
-- =====================================================================
-- UNIVESP - Banco de Dados (COM300)
-- Exercício 2: Módulo de Submissão de Artigos e Autores
-- =====================================================================

-- Tabela de Evento Acadêmico (Necessária para criar o vínculo 1:N)
CREATE TABLE evento_academico (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    sigla VARCHAR(20) NOT NULL
);

-- 1. Criação da tabela Autor
CREATE TABLE autor (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    titulo_academico VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- 2. Criação da tabela Artigo Científico (Relacionamento 1:N com Evento)
-- O campo id_evento é NOT NULL para impedir artigos sem evento associado
CREATE TABLE artigo_cientifico (
    id_artigo INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(250) NOT NULL,
    palavras_chave VARCHAR(200) NOT NULL,
    id_evento INT NOT NULL,
    FOREIGN KEY (id_evento) REFERENCES evento_academico(id_evento) ON DELETE RESTRICT
);

-- 3. Tabela intermediária de Autoria (Relacionamento N:M entre Artigo e Autor)
CREATE TABLE artigo_autor (
    id_artigo INT,
    cpf_autor VARCHAR(11),
    PRIMARY KEY (id_artigo, cpf_autor),
    FOREIGN KEY (id_artigo) REFERENCES artigo_cientifico(id_artigo) ON DELETE CASCADE,
    FOREIGN KEY (cpf_autor) REFERENCES autor(cpf) ON DELETE CASCADE
);

-- =====================================================================
-- Carga de Dados Fictícios para Testes (DML)
-- =====================================================================

INSERT INTO evento_academico (nome, sigla) VALUES ('Congresso de Banco de Dados', 'CBD');

INSERT INTO autor VALUES 
('11122233344', 'Carlos Eduardo', 'Doutor', 'carlos@univesp.br'),
('55566677788', 'Ana Maria Souza', 'Mestre', 'ana.souza@email.com');

INSERT INTO artigo_cientifico (titulo, palavras_chave, id_evento) VALUES 
('Otimização de Índices no MySQL 8', 'MySQL, Performance, Índices', 1),
('Abordagens Modernas em Bancos NoSQL', 'NoSQL, MongoDB, Big Data', 1);

-- Vinculando autores aos artigos (Carlos escreveu o artigo 1, Ana e Carlos escreveram o artigo 2)
INSERT INTO artigo_autor VALUES 
(1, '11122233344'),
(2, '11122233344'),
(2, '55566677788');

-- =====================================================================
-- Consulta de Relatório (Múltiplos JOINs)
-- =====================================================================

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
