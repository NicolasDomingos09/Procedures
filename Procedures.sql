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

-- Calcular IMC
CREATE PROCEDURE sp_calcular_IMC(@altura DECIMAL(4, 2), @peso DECIMAL(4, 2), @res DECIMAL(4, 2) OUTPUT)
AS
    SET @res = @peso / (@altura * @altura);

-- Buscar Atividade
CREATE PROCEDURE sp_buscar_atividade(@IMC DECIMAL(4, 2), @codigo INT OUTPUT)
AS
    IF @IMC < 18.5
        BEGIN
            SET @codigo = 1;
        END
    IF @IMC BETWEEN 18.6 AND 24.9
        BEGIN
            SET @codigo = 2;
        END
    IF @IMC BETWEEN 25 AND 29.9
        BEGIN
            SET @codigo = 3;
        END
    IF @IMC BETWEEN 30 AND 34.9
        BEGIN
            SET @codigo = 4;
        END
    IF @IMC > 35
        BEGIN
            SET @codigo = 5;
        END

-- Cadastrar Atividade do Aluno
CREATE PROCEDURE sp_atividade_aluno(@codigo_aluno INT, @nome VARCHAR(100), @altura DECIMAL(4, 2), @peso DECIMAL(4, 2))
AS
DECLARE @IMC DECIMAL(4, 2);
DECLARE @codigo_atividade INT
    IF @codigo_aluno IS NULL AND @nome IS NOT NULL AND @altura IS NOT NULL AND @peso IS NOT NULL
        BEGIN
            DECLARE @idAluno INT;
            SET @idAluno = ISNULL(((SELECT MAX(codigo_aluno) FROM Aluno) + 1), 1)
            INSERT INTO Aluno (codigo_aluno, nome)
            VALUES (@idAluno, @nome)
            EXEC sp_calcular_IMC @altura, @peso, @IMC OUTPUT
            EXEC sp_buscar_atividade @IMC, @codigo_atividade OUTPU
            INSERT INTO Atividade_Aluno (codigo_aluno, altura, peso, IMC, atividade)
            VALUES (@idAluno, @altura, @peso, @IMC, @codigo_atividade);
        END
    ELSE
        BEGIN
            IF (SELECT COUNT(*) FROM Aluno WHERE codigo_aluno = @codigo_aluno) = 1
                BEGIN
                    EXEC sp_calcular_IMC @altura, @peso, @IMC OUTPUT
                    EXEC sp_buscar_atividade @IMC, @codigo_atividade OUTPUT
                    UPDATE Atividade_Aluno
                    SET altura = @altura,
                        peso   = @peso,
                        IMC    = @IMC,
                        atividade = @codigo_atividade
                    WHERE codigo_aluno = @codigo_aluno;
                END
            ELSE
                BEGIN
                    RAISERROR (N'Código de aluno não existe', 16, 1)
                END
        END

-- TESTES
EXEC sp_atividade_aluno NULL, 'João', 1.75, 85.00
EXEC sp_atividade_aluno NULL, 'Pedro', 1.80, 95.00
EXEC sp_atividade_aluno 1, NULL, 1.75, 72.00

