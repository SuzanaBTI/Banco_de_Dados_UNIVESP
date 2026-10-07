-- ==========================================
-- EXERCÍCIO SQL - EMENTA UNIVESP
-- ==========================================

-- 1. DDL: Criação da estrutura de dados para o cenário acadêmico
CREATE TABLE universidade (
    cnpj VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    sigla VARCHAR(20) NOT NULL
);

CREATE TABLE evento_academico (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    sigla VARCHAR(20) NOT NULL,
    edicao VARCHAR(20) NOT NULL,
    tema VARCHAR(200) NOT NULL,
    area_concentracao VARCHAR(100) NOT NULL
);

-- Tabela intermediária para relacionamento M:N (Promove)
CREATE TABLE evento_promotora (
    id_evento INT,
    cnpj_universidade VARCHAR(14),
    PRIMARY KEY (id_evento, cnpj_universidade),
    FOREIGN KEY (id_evento) REFERENCES evento_academico(id_evento) ON DELETE CASCADE,
    FOREIGN KEY (cnpj_universidade) REFERENCES universidade(cnpj) ON DELETE CASCADE
);

-- 2. DML: Inserção de dados de teste (Mapeamento Posicional e Declarativo)
INSERT INTO universidade (cnpj, nome, sigla) 
VALUES ('12345678000199', 'Universidade Virtual do Estado de São Paulo', 'UNIVESP');

INSERT INTO evento_academico (nome, sigla, edicao, tema, area_concentracao) 
VALUES ('Simpósio de Tecnologia e Dados', 'STD', '2ª Edição', 'Bancos de Dados Modernos', 'Tecnologia da Informação');

INSERT INTO evento_promotora (id_evento, cnpj_universidade) VALUES (1, '12345678000199');

-- 3. DQL: Consulta Avançada usando INNER JOIN e Funções de Agregação
SELECT 
    e.nome AS Nome_Evento,
    e.sigla AS Sigla_Evento,
    u.nome AS Universidade_Promotora
FROM evento_academico e
INNER JOIN evento_promotora ep ON e.id_evento = ep.id_evento
INNER JOIN universidade u ON ep.cnpj_universidade = u.cnpj
WHERE e.area_concentracao = 'Tecnologia da Informação'
ORDER BY e.nome ASC;
