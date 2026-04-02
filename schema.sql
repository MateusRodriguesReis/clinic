-- ============================================================
--  SISTEMA DE CLÍNICA MÉDICA
--  Oracle SQL Developer — DDL + DML
--  Autor: Mateus Rodrigues Reis
--  GitHub: github.com/MateusRodriguesReis
-- ============================================================

-- Limpar objetos anteriores (executar se necessário)
-- DROP TABLE PRONTUARIO CASCADE CONSTRAINTS;
-- DROP TABLE CONSULTA CASCADE CONSTRAINTS;
-- DROP TABLE CONVENIO CASCADE CONSTRAINTS;
-- DROP TABLE PACIENTE CASCADE CONSTRAINTS;
-- DROP TABLE MEDICO CASCADE CONSTRAINTS;
-- DROP TABLE ESPECIALIDADE CASCADE CONSTRAINTS;


-- ============================================================
--  TABELA: ESPECIALIDADE
-- ============================================================
CREATE TABLE ESPECIALIDADE (
    id_especialidade  NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome              VARCHAR2(100)   NOT NULL,
    descricao         VARCHAR2(255),
    ativo             NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT chk_esp_ativo CHECK (ativo IN (0, 1))
);

COMMENT ON TABLE  ESPECIALIDADE               IS 'Especialidades médicas disponíveis na clínica';
COMMENT ON COLUMN ESPECIALIDADE.nome          IS 'Nome da especialidade (ex: Cardiologia)';
COMMENT ON COLUMN ESPECIALIDADE.ativo         IS '1 = ativa, 0 = inativa';


-- ============================================================
--  TABELA: MEDICO
-- ============================================================
CREATE TABLE MEDICO (
    id_medico         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome              VARCHAR2(150)   NOT NULL,
    crm               VARCHAR2(20)    NOT NULL,
    id_especialidade  NUMBER          NOT NULL,
    telefone          VARCHAR2(20),
    email             VARCHAR2(100),
    ativo             NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT uq_medico_crm     UNIQUE (crm),
    CONSTRAINT chk_medico_ativo  CHECK  (ativo IN (0, 1)),
    CONSTRAINT fk_medico_esp     FOREIGN KEY (id_especialidade)
        REFERENCES ESPECIALIDADE (id_especialidade)
);

COMMENT ON TABLE  MEDICO                   IS 'Cadastro de médicos da clínica';
COMMENT ON COLUMN MEDICO.crm              IS 'Registro no Conselho Regional de Medicina';
COMMENT ON COLUMN MEDICO.id_especialidade IS 'FK para ESPECIALIDADE';


-- ============================================================
--  TABELA: PACIENTE
-- ============================================================
CREATE TABLE PACIENTE (
    id_paciente      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome             VARCHAR2(150)   NOT NULL,
    cpf              VARCHAR2(14)    NOT NULL,
    data_nascimento   DATE            NOT NULL,
    sexo              CHAR(1)         NOT NULL,
    telefone         VARCHAR2(20),
    email            VARCHAR2(100)   NOT NULL UNIQUE,
    senha            VARCHAR2(255)   NOT NULL,
    ativo            NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT chk_paciente_ativo CHECK (ativo IN (0, 1))
);

COMMENT ON TABLE  PACIENTE               IS 'Cadastro de pacientes da clínica';
COMMENT ON COLUMN PACIENTE.email         IS 'Email único do paciente';
COMMENT ON COLUMN PACIENTE.senha         IS 'Senha do paciente (hash armazenado)';
COMMENT ON COLUMN PACIENTE.sexo               IS 'M = Masculino, F = Feminino, O = Outro';
COMMENT ON COLUMN PACIENTE.data_cadastro      IS 'Data de primeiro cadastro no sistema';


-- ============================================================
--  TABELA: CONVENIO
-- ============================================================
CREATE TABLE CONVENIO (
    id_convenio           NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente           NUMBER        NOT NULL,
    operadora             VARCHAR2(100) NOT NULL,
    numero_carteirinha    VARCHAR2(50)  NOT NULL,
    plano                 VARCHAR2(80),
    validade              DATE,
    CONSTRAINT fk_convenio_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE
);

COMMENT ON TABLE  CONVENIO                        IS 'Convênios vinculados a pacientes';
COMMENT ON COLUMN CONVENIO.numero_carteirinha    IS 'Número da carteirinha do convênio';


-- ============================================================
--  TABELA: CONSULTA
-- ============================================================
CREATE TABLE CONSULTA (
    id_consulta       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente       NUMBER          NOT NULL,
    id_medico         NUMBER          NOT NULL,
    data_consulta     DATE            NOT NULL,
    hora_consulta     VARCHAR2(5)     NOT NULL,
    status            VARCHAR2(20)    DEFAULT 'AGENDADA' NOT NULL,
    motivo            VARCHAR2(255),
    valor             NUMBER(10, 2),
    CONSTRAINT chk_consulta_status CHECK (
        status IN ('AGENDADA', 'REALIZADA', 'CANCELADA', 'FALTA')
    ),
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente),
    CONSTRAINT fk_consulta_medico FOREIGN KEY (id_medico)
        REFERENCES MEDICO (id_medico)
);

COMMENT ON TABLE  CONSULTA                  IS 'Agendamentos e histórico de consultas';
COMMENT ON COLUMN CONSULTA.status          IS 'AGENDADA | REALIZADA | CANCELADA | FALTA';
COMMENT ON COLUMN CONSULTA.hora_consulta   IS 'Formato HH:MM';


-- ============================================================
--  TABELA: PRONTUARIO
-- ============================================================
CREATE TABLE PRONTUARIO (
    id_prontuario     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_consulta       NUMBER          NOT NULL,
    diagnostico       VARCHAR2(500),
    prescricao        VARCHAR2(500),
    observacoes       VARCHAR2(500),
    data_registro     DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT uq_prontuario_consulta UNIQUE (id_consulta),
    CONSTRAINT fk_prontuario_consulta FOREIGN KEY (id_consulta)
        REFERENCES CONSULTA (id_consulta)
);

COMMENT ON TABLE  PRONTUARIO                    IS 'Prontuários médicos vinculados a consultas realizadas';
COMMENT ON COLUMN PRONTUARIO.diagnostico       IS 'CID e descrição do diagnóstico';
COMMENT ON COLUMN PRONTUARIO.prescricao        IS 'Medicamentos e orientações prescritos';


-- ============================================================
--  ÍNDICES
-- ============================================================
CREATE INDEX idx_consulta_data     ON CONSULTA (data_consulta);
CREATE INDEX idx_consulta_status   ON CONSULTA (status);
CREATE INDEX idx_consulta_medico   ON CONSULTA (id_medico);
CREATE INDEX idx_consulta_paciente ON CONSULTA (id_paciente);
CREATE INDEX idx_paciente_cpf      ON PACIENTE  (cpf);


-- ============================================================
--  DML — DADOS DE EXEMPLO
-- ============================================================

-- Especialidades
INSERT INTO ESPECIALIDADE (nome, descricao) VALUES ('Clínica Geral',    'Atendimento geral e triagem');
INSERT INTO ESPECIALIDADE (nome, descricao) VALUES ('Cardiologia',      'Doenças do coração e sistema circulatório');
INSERT INTO ESPECIALIDADE (nome, descricao) VALUES ('Dermatologia',     'Doenças da pele, cabelo e unhas');
INSERT INTO ESPECIALIDADE (nome, descricao) VALUES ('Pediatria',        'Atendimento a crianças e adolescentes');
INSERT INTO ESPECIALIDADE (nome, descricao) VALUES ('Ortopedia',        'Ossos, articulações e musculatura');

-- Médicos
INSERT INTO MEDICO (nome, crm, id_especialidade, telefone, email)
    VALUES ('Dr. Carlos Lima',     'CRM/RJ-12345', 1, '(21) 99001-1111', 'carlos.lima@clinica.com');
INSERT INTO MEDICO (nome, crm, id_especialidade, telefone, email)
    VALUES ('Dra. Ana Ferreira',   'CRM/RJ-23456', 2, '(21) 99001-2222', 'ana.ferreira@clinica.com');
INSERT INTO MEDICO (nome, crm, id_especialidade, telefone, email)
    VALUES ('Dr. Paulo Souza',     'CRM/RJ-34567', 3, '(21) 99001-3333', 'paulo.souza@clinica.com');
INSERT INTO MEDICO (nome, crm, id_especialidade, telefone, email)
    VALUES ('Dra. Mariana Costa',  'CRM/RJ-45678', 4, '(21) 99001-4444', 'mariana.costa@clinica.com');

-- Pacientes
INSERT INTO PACIENTE (nome, cpf, data_nascimento, sexo, telefone, email, endereco, cep)
    VALUES ('João Silva',       '111.222.333-44', DATE '1990-03-15', 'M', '(21) 98000-0001', 'joao@email.com',    'Rua das Flores, 100 — Madureira',    '21300-000');
INSERT INTO PACIENTE (nome, cpf, data_nascimento, sexo, telefone, email, endereco, cep)
    VALUES ('Maria Oliveira',   '222.333.444-55', DATE '1985-07-22', 'F', '(21) 98000-0002', 'maria@email.com',   'Av. Brasil, 500 — Centro',           '20900-000');
INSERT INTO PACIENTE (nome, cpf, data_nascimento, sexo, telefone, email, endereco, cep)
    VALUES ('Pedro Santos',     '333.444.555-66', DATE '2000-11-30', 'M', '(21) 98000-0003', 'pedro@email.com',   'Rua Uruguai, 40 — Tijuca',           '20510-060');
INSERT INTO PACIENTE (nome, cpf, data_nascimento, sexo, telefone, email, endereco, cep)
    VALUES ('Luciana Rocha',    '444.555.666-77', DATE '1978-01-05', 'F', '(21) 98000-0004', 'luciana@email.com', 'Rua Conde de Bonfim, 200 — Tijuca',  '20520-050');

-- Convênios
INSERT INTO CONVENIO (id_paciente, operadora, numero_carteirinha, plano, validade)
    VALUES (1, 'Unimed',    '1234567890', 'Unimed Nacional Enfermaria', DATE '2026-12-31');
INSERT INTO CONVENIO (id_paciente, operadora, numero_carteirinha, plano, validade)
    VALUES (2, 'Bradesco',  '9876543210', 'Bradesco Saúde Top',         DATE '2025-06-30');
INSERT INTO CONVENIO (id_paciente, operadora, numero_carteirinha, plano, validade)
    VALUES (3, 'SulAmérica','1122334455', 'SulAmérica Especial 200',    DATE '2027-03-15');

-- Consultas
INSERT INTO CONSULTA (id_paciente, id_medico, data_consulta, hora_consulta, status, motivo, valor)
    VALUES (1, 1, DATE '2025-07-10', '09:00', 'REALIZADA',  'Dor de cabeça frequente',     150.00);
INSERT INTO CONSULTA (id_paciente, id_medico, data_consulta, hora_consulta, status, motivo, valor)
    VALUES (2, 2, DATE '2025-07-12', '10:30', 'REALIZADA',  'Palpitações e cansaço',       250.00);
INSERT INTO CONSULTA (id_paciente, id_medico, data_consulta, hora_consulta, status, motivo, valor)
    VALUES (3, 1, DATE '2025-07-15', '14:00', 'AGENDADA',   'Consulta de rotina',          150.00);
INSERT INTO CONSULTA (id_paciente, id_medico, data_consulta, hora_consulta, status, motivo, valor)
    VALUES (4, 3, DATE '2025-07-16', '11:00', 'AGENDADA',   'Manchas na pele',             200.00);
INSERT INTO CONSULTA (id_paciente, id_medico, data_consulta, hora_consulta, status, motivo, valor)
    VALUES (1, 2, DATE '2025-07-20', '08:00', 'CANCELADA',  'Acompanhamento cardíaco',     250.00);

-- Prontuários (apenas para consultas REALIZADAS)
INSERT INTO PRONTUARIO (id_consulta, diagnostico, prescricao, observacoes)
    VALUES (1, 'G43 — Enxaqueca sem aura',
               'Dipirona 500mg — 1 comprimido a cada 6h por 3 dias',
               'Paciente orientado a reduzir cafeína e manter hidratação.');
INSERT INTO PRONTUARIO (id_consulta, diagnostico, prescricao, observacoes)
    VALUES (2, 'R00.0 — Taquicardia',
               'Atenolol 25mg — 1 comprimido em jejum por 30 dias',
               'Solicitar ECG e Holter 24h. Retorno em 30 dias.');

COMMIT;


-- ============================================================
--  VIEWS PARA RELATÓRIOS
-- ============================================================

-- View: Consultas completas com nomes
CREATE OR REPLACE VIEW VW_CONSULTAS AS
SELECT
    c.id_consulta,
    p.nome           AS paciente,
    p.cpf,
    m.nome           AS medico,
    e.nome           AS especialidade,
    c.data_consulta,
    c.hora_consulta,
    c.status,
    c.motivo,
    c.valor
FROM CONSULTA c
JOIN PACIENTE     p ON c.id_paciente      = p.id_paciente
JOIN MEDICO       m ON c.id_medico        = m.id_medico
JOIN ESPECIALIDADE e ON m.id_especialidade = e.id_especialidade;

-- View: Resumo por médico
CREATE OR REPLACE VIEW VW_RESUMO_MEDICO AS
SELECT
    m.nome                                      AS medico,
    e.nome                                      AS especialidade,
    COUNT(c.id_consulta)                        AS total_consultas,
    SUM(CASE WHEN c.status = 'REALIZADA'  THEN 1 ELSE 0 END) AS realizadas,
    SUM(CASE WHEN c.status = 'CANCELADA'  THEN 1 ELSE 0 END) AS canceladas,
    SUM(CASE WHEN c.status = 'AGENDADA'   THEN 1 ELSE 0 END) AS agendadas,
    NVL(SUM(CASE WHEN c.status = 'REALIZADA' THEN c.valor END), 0) AS receita_total
FROM MEDICO m
JOIN ESPECIALIDADE e ON m.id_especialidade = e.id_especialidade
LEFT JOIN CONSULTA c ON m.id_medico = c.id_medico
GROUP BY m.nome, e.nome;

-- View: Pacientes com convênio
CREATE OR REPLACE VIEW VW_PACIENTES_CONVENIO AS
SELECT
    p.nome                  AS paciente,
    p.cpf,
    p.telefone,
    cv.operadora,
    cv.plano,
    cv.numero_carteirinha,
    cv.validade,
    CASE WHEN cv.validade >= SYSDATE THEN 'VÁLIDO' ELSE 'VENCIDO' END AS situacao
FROM PACIENTE p
LEFT JOIN CONVENIO cv ON p.id_paciente = cv.id_paciente;


-- ============================================================
--  QUERIES DE RELATÓRIO
-- ============================================================

-- 1. Consultas do dia
SELECT * FROM VW_CONSULTAS
WHERE data_consulta = TRUNC(SYSDATE)
ORDER BY hora_consulta;

-- 2. Faturamento por mês
SELECT
    TO_CHAR(data_consulta, 'YYYY-MM') AS mes,
    COUNT(*)                          AS total_consultas,
    SUM(valor)                        AS faturamento
FROM CONSULTA
WHERE status = 'REALIZADA'
GROUP BY TO_CHAR(data_consulta, 'YYYY-MM')
ORDER BY mes DESC;

-- 3. Pacientes com mais consultas
SELECT
    p.nome,
    COUNT(c.id_consulta) AS total_consultas
FROM PACIENTE p
JOIN CONSULTA c ON p.id_paciente = c.id_paciente
GROUP BY p.nome
ORDER BY total_consultas DESC
FETCH FIRST 10 ROWS ONLY;

-- 4. Relatório completo de médicos
SELECT * FROM VW_RESUMO_MEDICO ORDER BY total_consultas DESC;
