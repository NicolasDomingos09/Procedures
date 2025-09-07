CREATE DATABASE Academia;
USE Academia;

CREATE TABLE Aluno
(
    codigo_aluno INT,
    nome         VARCHAR(100)
        PRIMARY KEY (codigo_aluno)
);

CREATE TABLE Atividade
(
    codigo    INT,
    descricao VARCHAR(255),
    IMC       DECIMAL(4, 2)
        PRIMARY KEY (codigo)
);

CREATE TABLE Atividade_Aluno
(
    codigo_aluno INT,
    altura       DECIMAL(4, 2),
    peso         DECIMAL(4, 2),
    IMC          DECIMAL(4, 2),
    atividade    INT
        PRIMARY KEY (codigo_aluno, atividade)
        FOREIGN KEY (codigo_aluno) REFERENCES Aluno (codigo_aluno),
    FOREIGN KEY (atividade) REFERENCES Atividade (codigo)
);

INSERT INTO Atividade
VALUES (1, 'Corrida + Step', 18.5),
       (2, 'Biceps + Costas + Pernas', 24.9),
       (3, 'Esteira + Biceps + Costas + Pernas', 29.9),
       (4, 'Bicicleta + Biceps + Costas + Pernas', 34.9),
       (5, 'Esteira + Bicicleta', 39.9);

-- Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
-- Exemplo, se o IMC for igual a 27, deve-se fazer a atividade para IMC = 29.9
-- * Caso o IMC seja maior que 40, utilizar o código 5.


