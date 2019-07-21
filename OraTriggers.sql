/*TRIGGERS DEVEM TER O TAMANHO MAXIMO DE 32K
NÃO EXECUTAM COMANDOS DE DTL - COMMIT, ROLLBACK E SAVEPOINTS*/

-- VALIDACAO

CREATE OR REPLACE TRIGGER CHECK_SALARIO
BEFORE INSERT OR UPDATE ON ALUNO
FOR EACH ROW
BEGIN
	IF :NEW.SALARIO > 2000 THEN
		RAISE_APPLICATION_ERROR(-20000, 'VALOR INCORRETO');
	END IF;
END;
/

SHOW ERRORS;

INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL, 'LEO', 'LEO@TESTE.COM', 4000.00);

--TRIGGERS DO BANCO
SELECT TRIGGER_NAME, TRIGGER_BODY
FROM USER_TRIGGERS;

--TRIGGER DE EVENTOS
CREATE TABLE AUDITORIA(
	DATA_LOGIN DATE,
	LOGIN VARCHAR2(30)
);

CREATE OR REPLACE PROCEDURE LOGPROC IS
BEGIN
	INSERT INTO AUDITORIA(DATA_LOGIN, LOGIN)
	VALUES(SYSDATE, USER);
END LOGPROC;
/

CREATE OR REPLACE TRIGGER LOGTRIGGER
AFTER LOGON ON DATABASE
CALL LOGPROC
/

CREATE TABLE USUARIO(
	ID INT,
	NOME VARCHAR2(30)
);

CREATE TABLE BKP_USER(
	ID INT,
	NOME VARCHAR2(30)
);

INSERT INTO USUARIO VALUES(1,'JOAO');
INSERT INTO USUARIO VALUES(2,'MARIA');
COMMIT;

SELECT * FROM USUARIO;

CREATE OR REPLACE TRIGGER LOG_USUARIO
BEFORE DELETE ON USUARIO
FOR EACH ROW
BEGIN
	INSERT INTO BKP_USER VALUES
	(:OLD.ID,:OLD.NOME);
END;

DELETE FROM USUARIO WHERE ID = 1;
COMMIT;

SELECT * FROM BKP_USER;