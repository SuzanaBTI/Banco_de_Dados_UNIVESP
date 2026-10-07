sql
-- =====================================================================
-- UNIVESP - Banco de Dados (COM300)
-- Exercício 3: Implementação de Prédios, Salas e Reservas
-- =====================================================================

-- 1. Criação da tabela de Eventos Acadêmicos
CREATE TABLE evento_academico (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    sigla VARCHAR(20) NOT NULL
);

-- 2. Criação da tabela de Prédios (Entidade Forte)
CREATE TABLE predio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL
);

-- 3. Criação da tabela de Salas (Entidade Fraca)
CREATE TABLE sala (
    id_predio INT,
    numero INT,
    valor DECIMAL(10, 2) NOT NULL,
    qtde_cadeiras INT NOT NULL,
    recursos TEXT, 
    PRIMARY KEY (id_predio, numero),
    FOREIGN KEY (id_predio) REFERENCES predio(id) ON DELETE CASCADE
);

-- 4. Criação da tabela de Reservas (Relacionamento N:M com Atributos)
CREATE TABLE reserva (
    id_evento INT,
    id_predio INT,
    numero_sala INT,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    PRIMARY KEY (id_evento, id_predio, numero_sala, data_inicio),
    FOREIGN KEY (id_evento) REFERENCES evento_academico(id_evento) ON DELETE CASCADE,
    FOREIGN KEY (id_predio, numero_sala) REFERENCES sala(id_predio, numero) ON DELETE CASCADE
);

-- =====================================================================
-- Carga de Dados Fictícios para Testes (DML)
-- =====================================================================

INSERT INTO evento_academico (nome, sigla) VALUES 
('Simpósio de IA', 'SIA'), 
('Congresso de Redes', 'CR');

INSERT INTO predio (rua, numero, city, estado) VALUES 
('Av. Paulista', '1000', 'São Paulo', 'SP');

INSERT INTO sala VALUES 
(1, 101, 250.00, 40, 'Projetor, Ar-condicionado'), 
(1, 102, 400.00, 80, 'Projetor, Caixas de Som, Microfone');

INSERT INTO reserva VALUES 
(1, 1, 101, '2026-10-15 08:00:00', '2026-10-15 12:00:00'),
(2, 1, 102, '2026-10-15 14:00:00', '2026-10-15 18:00:00');

-- =====================================================================
-- Consulta de Relatório (INNER JOIN)
-- =====================================================================

SELECT 
    e.sigla AS Evento,
    p.rua AS Local_Predio,
    r.numero_sala AS Sala,
    r.data_inicio AS Inicio,
    r.data_fim AS Termino
FROM reserva r
INNER JOIN evento_academico e ON r.id_evento = e.id_evento
INNER JOIN predio p ON r.id_predio = p.id;
