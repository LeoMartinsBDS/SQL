/*TUDO NO ORACLE NECESSITA DE USAR O FROM*/

SELECT 1 + 1; -- NO ORACLE NAO FUNCIONA

SELECT 1 + 1 AS SOMA FROM DUAL; -- DESSE JEITO FUNCIONA, É NECESSÁRIO COLOCAR O DUAL, QUE É UMA TABELA DUMMY

/*VERIFICANDO O AMBIENTE*/
-- B023 -> 32 BITS
-- B047 -> 64 BITS

SELECT METADATA FROM SYS.KOPM$;

/*DICIONARIO DE DADOS*/

SELECT * FROM DICT;

-- UNICA - RAC(CLUSTER)
-- V$ É VIEW
SELECT PARALLEL FROM V$INSTANCE;

-- ESTRUTURAS DE MEMORIA
SELECT COMPONENT, CURRENT_SIZE, MIN_SIZE, MAX_SIZE
FROM V$SGA_DYNAMIC_COMPONENTS

-- CONECTANDO A OUTRO BANCO DE DADOS
SQLPLUS SYSTEM/SENHA@NOMEDOBANCO

-- NOME DO BANCO DE DADOS
SELECT NAME FROM V$DATABASE;

-- VERSAO DO BANCO
SELECT BANNER FROM V$VERSION;

-- VERIFICAR PRIVILEGIOS DOS USUARIOS
SELECT * FROM USER_SYS_PRIVS;

-- TABELAS DO USUARIO
SELECT TABLE_NAME FROM USER_TABLES;

/*
ARMAZENAMENTO
LOGICO - TABLESPACES -> SEGMENTOS(OBJETOS)
EXTENSOES (ESPAÇO) -> BLOCOS (DO SISTEMA OPERACIONAL)

FISICO -> DATAFILES
*/

CREATE TABLE CURSOS(
	IDCURSO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	CARGA INT
)TABLESPACE USERS;

CREATE TABLE TESTE(
	IDTESTE INT,
	NOME VARCHAR2(30)
);

--DD

SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES
WHERE TABLE_NAME = 'CURSOS';


SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES
WHERE TABLE_NAME = 'TESTE'; -- TODO OBJETO É CRIADO POR PADRÃO NA TABLESPACE USERS, EXCETO QUANTO SE ESTA LOGADO COM O USUARIO SYSTEM.

SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME,
BYTES, BLOCKS, EXTENTS FROM USER_SEGMENTS;

/*TABLESPACES*/
CREATE TABLESPACE RECURSOS_HUMANOS
DATAFILE 'C:/DATA/RH_01.DBF'
SIZE 100M AUTOEXTEND
ON NEXT 100M
MAXSIZE 4096M;

ALTER TABLESPACE RECURSOS_HUMANOS
ADD DATAFILE 'C:/DATA/RH_02.DBF'
SIZE 200M AUTOEXTEND
ON NEXT 200M
MAXSIZE 4096M;

SELEC TABLESPACE_NAME, FILE_NAME FROM DBA_DATA_FILES;

-- SEQUENCES

CREATE SEQUENCE SEQ_GERAL
START WITH 100
INCREMENT BY 10;

-- CRIANDO UMA TABELA NA TABLESPACE

CREATE TABLE FUNCIONARIOS(
	IDFUNCIONARIO INT PRIMARY KEY,
	NOME VARCHAR2(30) -- TIPO NOVO DO ORACLE IGUAL AO VARCHAR, POREM, COM MAIS CAPACIDADE (VARCHAR É PONTEIRAMENTO PARA VARCHAR2)
) TABLESPACE RECURSOS_HUMANOS;

INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL, 'JOAO');
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL, 'CLARA');
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL, 'LILIAN');

SELECT * FROM FUNCIONARIOS

COMMIT;