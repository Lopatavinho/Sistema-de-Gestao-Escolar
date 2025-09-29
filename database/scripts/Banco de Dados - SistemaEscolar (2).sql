-- Criar banco de dados
CREATE DATABASE SistemaEscolar;
USE SistemaEscolar;

-- Usuários do sistema (login)
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL, -- senha deve ser armazenada com hash
    perfil ENUM('Aluno','Professor','Administrador') NOT NULL
);

-- Alunos
CREATE TABLE Aluno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    matricula VARCHAR(20) UNIQUE NOT NULL, -- matrícula única
    data_nascimento DATE,
    usuario_id INT UNIQUE,
    CONSTRAINT fk_aluno_usuario FOREIGN KEY (usuario_id) REFERENCES Usuario(id)
);

-- Professores
CREATE TABLE Professor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    usuario_id INT UNIQUE,
    CONSTRAINT fk_professor_usuario FOREIGN KEY (usuario_id) REFERENCES Usuario(id)
);

-- Disciplinas
CREATE TABLE Disciplina (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Vínculo Professor-Disciplina (um professor pode lecionar várias disciplinas)
CREATE TABLE ProfessorDisciplina (
    id INT AUTO_INCREMENT PRIMARY KEY,
    professor_id INT NOT NULL,
    disciplina_id INT NOT NULL,
    CONSTRAINT fk_pd_professor FOREIGN KEY (professor_id) REFERENCES Professor(id),
    CONSTRAINT fk_pd_disciplina FOREIGN KEY (disciplina_id) REFERENCES Disciplina(id),
    CONSTRAINT uq_pd UNIQUE (professor_id, disciplina_id) -- não deixar duplicado
);

-- Turmas
CREATE TABLE Turma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    periodo_letivo VARCHAR(20) NOT NULL,
    professor_responsavel_id INT NOT NULL,
    CONSTRAINT uq_turma UNIQUE (nome, periodo_letivo), -- turma não pode repetir no mesmo período
    CONSTRAINT fk_turma_professor FOREIGN KEY (professor_responsavel_id) REFERENCES Professor(id)
);

-- Vínculo Turma-Disciplina (uma turma pode ter várias disciplinas)
CREATE TABLE TurmaDisciplina (
    id INT AUTO_INCREMENT PRIMARY KEY,
    turma_id INT NOT NULL,
    disciplina_id INT NOT NULL,
    CONSTRAINT fk_td_turma FOREIGN KEY (turma_id) REFERENCES Turma(id),
    CONSTRAINT fk_td_disciplina FOREIGN KEY (disciplina_id) REFERENCES Disciplina(id),
    CONSTRAINT uq_td UNIQUE (turma_id, disciplina_id)
);

-- Matrícula: vínculo Aluno-Turma por período letivo
CREATE TABLE AlunoTurma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT NOT NULL,
    turma_id INT NOT NULL,
    periodo_letivo VARCHAR(20) NOT NULL,
    CONSTRAINT fk_at_aluno FOREIGN KEY (aluno_id) REFERENCES Aluno(id),
    CONSTRAINT fk_at_turma FOREIGN KEY (turma_id) REFERENCES Turma(id),
    CONSTRAINT uq_aluno_periodo UNIQUE (aluno_id, periodo_letivo) -- garante 1 turma por período
);

-- Notas
CREATE TABLE Nota (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT NOT NULL,
    disciplina_id INT NOT NULL,
    professor_id INT NOT NULL,
    valor DECIMAL(4,2) NOT NULL CHECK (valor >= 0 AND valor <= 10),
    data_lancamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_nota_aluno FOREIGN KEY (aluno_id) REFERENCES Aluno(id),
    CONSTRAINT fk_nota_disciplina FOREIGN KEY (disciplina_id) REFERENCES Disciplina(id),
    CONSTRAINT fk_nota_professor FOREIGN KEY (professor_id) REFERENCES Professor(id)
);

-- Histórico de Notas (registra alterações: quem mudou, quando e valores)
CREATE TABLE HistoricoNota (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nota_id INT NOT NULL,
    valor_antigo DECIMAL(4,2),
    valor_novo DECIMAL(4,2),
    professor_id INT NOT NULL,
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_hn_nota FOREIGN KEY (nota_id) REFERENCES Nota(id),
    CONSTRAINT fk_hn_professor FOREIGN KEY (professor_id) REFERENCES Professor(id)
);

-- -------------------
-- Dados de exemplo
-- -------------------

-- Usuários
INSERT INTO Usuario (username, senha, perfil) VALUES ('aluno1', '123456', 'Aluno');
INSERT INTO Usuario (username, senha, perfil) VALUES ('prof1', '123456', 'Professor');
INSERT INTO Usuario (username, senha, perfil) VALUES ('admin', '123456', 'Administrador');

-- Aluno
INSERT INTO Aluno (nome, matricula, data_nascimento, usuario_id) 
VALUES ('João da Silva', '2025A001', '2008-05-10', 1);

-- Professor
INSERT INTO Professor (nome, usuario_id) VALUES ('Maria Oliveira', 2);

-- Disciplina
INSERT INTO Disciplina (nome) VALUES ('Matemática');

-- Vínculo Professor-Disciplina
INSERT INTO ProfessorDisciplina (professor_id, disciplina_id) VALUES (1, 1);

-- Turma
INSERT INTO Turma (nome, periodo_letivo, professor_responsavel_id) VALUES ('1º Ano A', '2025', 1);

-- Vínculo Turma-Disciplina
INSERT INTO TurmaDisciplina (turma_id, disciplina_id) VALUES (1, 1);

-- Matrícula Aluno-Turma
INSERT INTO AlunoTurma (aluno_id, turma_id, periodo_letivo) VALUES (1, 1, '2025');

-- Nota
INSERT INTO Nota (aluno_id, disciplina_id, professor_id, valor) VALUES (1, 1, 1, 8.5);

-- Histórico de Nota (exemplo de alteração)
INSERT INTO HistoricoNota (nota_id, valor_antigo, valor_novo, professor_id) VALUES (1, 8.5, 9.0, 1);
