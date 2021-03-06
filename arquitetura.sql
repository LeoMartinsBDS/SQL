/* ORGANIZAR FISICAMENTE E LOGICAMENTE UM BD

1- CRIAR BANCO COM ARQUIVOS PARA OS SETORES DE MKT E VENDAS
2- CRIAR UM ARQUIVO GERAL
3- DEIXAR O MDF APENAS COM O DD
4- CRIAR 2 GRUPOS DE ARQUIVOS
CLICAR SOBRE BANCO DE DADOS, CRIAR NOVO BANCO/GRUPO DE ARQUIVOS
EM GERAL ADICIONAMOS O ARQUIVO COM O GRUPO QUE FOI CRIADO E O SEU RESPECTIVO MDF

SQL SERVER POSSUI FILESTREAM -> ARMAZENAR ARQUIVOS DENTRO DE TABELA(EX: .DOC)
PODEM SER SALVOS EM GRUPO SEPARADO

*/
USE EMPRESA
GO

CREATE TABLE TB_EMPRESA(
	ID INT,
	NOME VARCHAR(50)

)
GO
------------------------------------------------
USE EMPRESA
GO

CREATE TABLE ALUNO(
	IDALUNO INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(30) NOT NULL,
	SEXO CHAR(1) NOT NULL,
	NASCIMENTO DATE NOT NULL,
	EMAIL VARCHAR(30) UNIQUE
)
GO

/*CONSTRAINTS*/
ALTER TABLE ALUNO 
ADD CONSTRAINT CK_SEXO CHECK (SEXO IN('M','F'))
GO

/*1X1*/
CREATE TABLE ENDERECO(
	IDENDERECO INT PRIMARY KEY IDENTITY(100,10), /*AUTO_INCREMENT DO SQL SERVER (INICIA, INCREMENTA)*/
	BAIRRO VARCHAR(30),
	UF CHAR(2) NOT NULL
	CHECK(UF IN('RJ','SP','MG')),
	ID_ALUNO INT UNIQUE
)
GO

/*CRIANDO A FK*/
ALTER TABLE ENDERECO
ADD CONSTRAINT FK_ENDERECO_ALUNO
FOREIGN KEY(ID_ALUNO) REFERENCES ALUNO(IDALUNO)
GO

/*COMANDOS DE DESCRICAO*/
/*PROCEDURE - JA CRIADAS E ARMAZENADAS NO SISTEMA*/
SP_COLUMNS ALUNO
GO

SP_HELP ALUNO
GO

INSERT INTO ALUNO VALUES('ANDRE','M', '1981/12/09', 'ANDRE@IG.COM')
INSERT INTO ALUNO VALUES('ANA','F', '1978/03/09', 'ANA@IG.COM')
INSERT INTO ALUNO VALUES('RUI','M', '1965/07/09', 'RUI@IG.COM')
INSERT INTO ALUNO VALUES('JOAO','M', '2002/11/09', 'JOAO@IG.COM')
GO

SELECT * FROM ALUNO
GO

INSERT INTO ENDERECO VALUES('FLAMENGO','RJ',1)
INSERT INTO ENDERECO VALUES('MORUMBI','SP',2)
INSERT INTO ENDERECO VALUES('CENTRO','MG',3)
INSERT INTO ENDERECO VALUES('CENTRO','SP',4)
GO

CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY IDENTITY,
	TIPO CHAR(3) NOT NULL,
	NUMERO VARCHAR(10) NOT NULL,
	ID_ALUNO INT,
	CHECK (TIPO IN ('RES','COM','CEL'))
)
GO

INSERT INTO TELEFONE VALUES('CEL', '7899889', 1)
INSERT INTO TELEFONE VALUES('RES', '4325444', 1)
INSERT INTO TELEFONE VALUES('COM', '4354354', 2)
INSERT INTO TELEFONE VALUES('CEL', '2344556', 2)
GO

/*PEGAR A DATA ATUAL*/

SELECT GETDATE()
GO

/*CLAUSULA AMBIGUA*/
SELECT A.NOME, 
	   ISNULL(T.TIPO, 'SEM') AS "TIPO", 
	   ISNULL(T.NUMERO, 'NUMERO') AS "NUMERO", 
	   E.BAIRRO,
	   E.UF
FROM ALUNO A
LEFT JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

/*DATAS*/

SELECT * FROM ALUNO
GO

SELECT NOME, NASCIMENTO
FROM ALUNO
GO

/*DATEDIFF - CALCULA A DIFERENCA ENTRE DUAS DATAS
FUNCAO GETDATE() TRAZ DIA E HORA
*/

SELECT NOME, GETDATE() AS DIA_HORA FROM ALUNO
GO

SELECT NOME, DATEDIFF(DAY,NASCIMENTO,GETDATE()) AS "IDADE"
FROM ALUNO
GO

/* 3 PASSO - RETORNO EM INTEIRO + OPER MATEMATICA*/
SELECT NOME, (DATEDIFF(DAY,NASCIMENTO,GETDATE())/365) AS "IDADE"
FROM ALUNO
GO

SELECT NOME, (DATEDIFF(MONTH,NASCIMENTO,GETDATE())/12) AS "IDADE"
FROM ALUNO
GO

SELECT NOME, DATEDIFF(YEAR,NASCIMENTO,GETDATE()) AS "IDADE"
FROM ALUNO
GO

/*DATENAME - TRAZ O NOME DA PARTE DA DATA EM QUEST�O - STRING */

SELECT NOME, DATENAME(MONTH, NASCIMENTO)
FROM ALUNO
GO

SELECT NOME, DATENAME(YEAR, NASCIMENTO)
FROM ALUNO
GO

SELECT NOME, DATENAME(WEEKDAY, NASCIMENTO)
FROM ALUNO
GO

/*DATEPART - POREM O RETORNO � UM INTEIRO*/

SELECT NOME, DATEPART(MONTH, NASCIMENTO), DATENAME(MONTH, NASCIMENTO)
FROM ALUNO
GO

/*DATEADD - RETORNA UMA DATA SOMANDO A OUTRA DATA*/
SELECT DATEADD(DAY, 365, GETDATE())
GO

SELECT DATEADD(YEAR, 10, GETDATE())
GO

/*CONVERSAO DE DADOS */

SELECT CAST('1' AS INT) + CAST ('1' AS INT)
GO

/*CONVERSAO E CONCATENACAO*/

SELECT NOME,
NASCIMENTO
FROM ALUNO
GO

SELECT NOME,
DAY(NASCIMENTO) + '/' + MONTH(NASCIMENTO) + '/' + YEAR(NASCIMENTO)
FROM ALUNO
GO

SELECT NOME,
CAST(DAY(NASCIMENTO) AS varchar) + '/' +
CAST(MONTH(NASCIMENTO) AS varchar) + '/' + 
CAST(YEAR(NASCIMENTO) AS varchar) AS NASCIMENTO
FROM ALUNO
GO

/*CHARINDEX - RETORNA UM INTEIRO
CONTAGEM DEFAULT - INICIA EM 01
*/

SELECT NOME, CHARINDEX('A',NOME) AS INDICE
FROM ALUNO
GO

/*BULK INSERT - IMPORTACAO DE ARQUIVOS */

CREATE TABLE LANCAMENTO_CONTABIL(
	CONTA INT,
	VALOR INT,
	DEB_CRED CHAR(1)
)
GO

SELECT * FROM LANCAMENTO_CONTABIL
GO

/*\t = TAB*/

BULK INSERT LANCAMENTO_CONTABIL
FROM 'C:\Users\Leonardo\Downloads\CONTAS.txt'
WITH 
(
	FIRSTROW = 2,
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = '\t',
	ROWTERMINATOR = '\n'
)
GO

SELECT * FROM LANCAMENTO_CONTABIL
GO

SELECT CONTA, VALOR, DEB_CRED,
CHARINDEX('D', DEB_CRED) AS DEBITO,
CHARINDEX('C', DEB_CRED) AS CREDITO,
CHARINDEX('C', DEB_CRED) * 2 - 1 AS MULTIPLICADOR
FROM LANCAMENTO_CONTABIL
GO

SELECT CONTA,
SUM(VALOR * (CHARINDEX('C', DEB_CRED) * 2 - 1)) AS SALDO
FROM LANCAMENTO_CONTABIL
GROUP BY CONTA
GO