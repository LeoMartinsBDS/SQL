/*No Linux o MYSQL é case sensitive*/
USE information_schema;

DESC TRIGGERS;

CREATE DATABASE AULA40;

USE AULA40;

CREATE TABLE USUARIO(
	IDUSUARIO INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30),
	LOGIN VARCHAR(30),
	SENHA VARCHAR(100)
);

CREATE TABLE BKP_USUARIO(
	IDBACKUP INT PRIMARY KEY AUTO_INCREMENT,
	IDUSUARIO INT,
	NOME VARCHAR(30),
	LOGIN VARCHAR(30)
);

/*TRIGGER*/
DELIMITER $

CREATE TRIGGER BACKUP_USER
BEFORE DELETE ON USUARIO
FOR EACH ROW
BEGIN
	
	INSERT INTO BKP_USUARIO VALUES
	(NULL,OLD.IDUSUARIO, OLD.NOME, OLD.LOGIN);
	
END
$

DELIMITER ;

INSERT INTO USUARIO VALUES(NULL, 'ANDRADE', 'ANDRADRE2009', '123');

SELECT * FROM USUARIO;

DELETE FROM USUARIO WHERE IDUSUARIO = 1;

SELECT * FROM BKP_USUARIO;

/*COMUNICAÇÃO ENTRE BANCOS*/

CREATE DATABASE LOJA;

USE LOJA;

CREATE TABLE PRODUTO(
	IDPRODUTO INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30),
	VALOR FLOAT(10,2)
);

CREATE DATABASE BACKUP;

USE BACKUP;

CREATE TABLE BKP_PRODUTO(
	IDBKP INT PRIMARY KEY AUTO_INCREMENT,
	IDPRODUTO INT,
	NOME VARCHAR(30),
	VALOR FLOAT(10,2)
);


USE LOJA;

/*COMUNICAO*/
INSERT INTO BACKUP.BKP_PRODUTO VALUES(NULL, 1000, 'TESTE', 0.0);

SELECT * FROM BACKUP.BKP_PRODUTO;

DELIMITER $

CREATE TRIGGER BACKUP_PRODUTO
BEFORE INSERT ON PRODUTO
FOR EACH ROW
BEGIN

	INSERT INTO BACKUP.BKP_PRODUTO VALUES
	(NULL, NEW.IDPRODUTO, NEW.NOME, NEW.VALOR);
	
END
$

DELIMITER ;
INSERT INTO PRODUTO VALUES(NULL,'LIVRO MODELAGEM', 50.00);
INSERT INTO PRODUTO VALUES(NULL,'LIVRO BI', 80.00);
INSERT INTO PRODUTO VALUES(NULL,'LIVRO ORACLE', 70.00);
INSERT INTO PRODUTO VALUES(NULL,'LIVRO SQL SERVER', 100.00);

SELECT * FROM PRODUTO;

SELECT * FROM BACKUP.BKP_PRODUTO;

DELIMITER $
CREATE TRIGGER BACKUP_PRODUTO_DEL
BEFORE DELETE ON PRODUTO
FOR EACH ROW
BEGIN

	INSERT INTO BACKUP.BKP_PRODUTO VALUES
	(NULL, OLD.IDPRODUTO, OLD.NOME, OLD.VALOR);
	
END
$

DELIMITER ;

DELETE FROM PRODUTO WHERE IDPRODUTO = 1;

SELECT * FROM BACKUP.BKP_PRODUTO;

DROP TRIGGER BACKUP_PRODUTO;

DELIMITER $

CREATE TRIGGER BACKUP_PRODUTO
AFTER INSERT ON PRODUTO
FOR EACH ROW
BEGIN

	INSERT INTO BACKUP.BKP_PRODUTO VALUES
	(NULL, NEW.IDPRODUTO, NEW.NOME, NEW.VALOR);
	
END
$
/*QUANDO É AUTO_INCREMENT, CASO SEJA BEFORE INSERT, ELE JOGARÁ O VALOR DO CAMPO COMO '0'
DEVIDO AO FATO DE ELE PEGAR O VALOR DE "ANTES". O AUTO_INCREMENT SÓ É EXECUTADO APÓS A EXECUÇAO
DO INSERT*/

DELIMITER ;

INSERT INTO PRODUTO VALUES(NULL,'LIVRO C#', 100.00);

SELECT * FROM BACKUP.BKP_PRODUTO;

ALTER TABLE BACKUP.BKP_PRODUTO
ADD EVENTO CHAR(1);

DROP TRIGGER BACKUP_PRODUTO_DEL;

DELIMITER $
CREATE TRIGGER BACKUP_PRODUTO_DEL
BEFORE DELETE ON PRODUTO
FOR EACH ROW
BEGIN

	INSERT INTO BACKUP.BKP_PRODUTO VALUES
	(NULL, OLD.IDPRODUTO, OLD.NOME, OLD.VALOR, 'D');
	
END
$

DELIMITER ;

DELETE FROM PRODUTO WHERE IDPRODUTO = 4;

SELECT * FROM BACKUP.BKP_PRODUTO;

/*AUDITORIA
SELECT NOW() -> QUANDO
SELECT CURRENT_USER() -> QUEM
*/
SELECT CURRENT_USER();