/* TSQL - � UM BLOCO DE LINGUAGEM DE PROGRAMA��O. 
PROGRAMAS S�O UNIDADES QUE PODEM SER CHAMADAS DE BLOCOS AN�NIMOS.
BLOCOS AN�NIMOS N�O RECEBEM NOME, POIS N�O S�O SALVOS NO BANCO. CRIAMOS
BLOCOS AN�NIMOS QUANDO IREMOS EXECUTA-LOS UMA S� VEZ OU TESTAR ALGO. */

/* BLOCO DE EXECU��O */
BEGIN
	PRINT 'PRIMEIRO BLOCO'
END
GO

/* BLOCOS DE ATRIBUI��O DE VARIAVEIS */

DECLARE
	@CONTADOR INT
BEGIN
	SET @CONTADOR = 5
	PRINT @CONTADOR
END
GO

/* CADA COLUNA, VARIAVEL LOCAL, EXPRESSAO E PARAMETRO TEM UM TIPO */

DECLARE 

	@V_NUMERO NUMERIC(10,2) = 100.52,
	@V_DATA DATETIME = '20170207'

BEGIN

	PRINT 'VALOR NUMERICO: ' + CAST(@V_NUMERO AS VARCHAR)
	PRINT 'VALOR NUMERICO: ' + CONVERT(VARCHAR, @V_NUMERO)
	PRINT 'VALOR DE DATA: ' + CAST(@V_DATA AS VARCHAR)
	PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA,121)
	PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA,120)
	PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA,105)
END
GO

CREATE TABLE CARROS(
	CARRO VARCHAR(20),
	FABRICANTE VARCHAR(30)
)
GO

INSERT INTO CARROS VALUES('KA','FORD')
INSERT INTO CARROS VALUES('FIESTA','FORD')
INSERT INTO CARROS VALUES('PRISMA','CHEVROLET')
INSERT INTO CARROS VALUES('CLIO','RENAULT')
INSERT INTO CARROS VALUES('SANDERO','RENAULT')
INSERT INTO CARROS VALUES('CHEVETE','CHEVROLET')
INSERT INTO CARROS VALUES('OMEGE','CHEVROLET')
INSERT INTO CARROS VALUES('PALIO','FIAT')
INSERT INTO CARROS VALUES('DOBLO','FIAT')
INSERT INTO CARROS VALUES('UNO','FIAT')
INSERT INTO CARROS VALUES('GOL','VOLKSWAGEN')
GO

DECLARE
	@V_CONT_FORD INT,
	@V_CONT_FIAT INT
BEGIN

	SET @V_CONT_FORD = (SELECT COUNT(*) FROM CARROS
						WHERE FABRICANTE = 'FORD')

	PRINT 'QUANTIDADE FORD: ' + CAST(@V_CONT_FORD AS VARCHAR)

	SELECT @V_CONT_FIAT = COUNT(*) FROM CARROS WHERE FABRICANTE = 'FIAT'

	PRINT 'QUANTIDADE FIAT: ' + CONVERT(VARCHAR, @V_CONT_FIAT)

END
GO

/* BLOCOS IF E ELSE */

DECLARE 
	@NUMERO INT = 5
BEGIN

	IF @NUMERO = 5
		PRINT 'O VALOR � VERDADEIRO'
	ELSE
		PRINT 'O VALOR � FALSO'
END
GO

/* CASE */

DECLARE
	@CONTADOR INT
BEGIN
	SELECT
	CASE
		WHEN FABRICANTE = 'FIAT' THEN 'FAIXA 1'
		WHEN FABRICANTE = 'CHEVROLET' THEN 'FAIXA 2'
		ELSE 'OUTRAS FAIXAS'
	END AS "INFORMACOES", *
	FROM CARROS
END
GO

/* LOOPS - WHILE */

DECLARE
	@I INT = 1
BEGIN
	WHILE(@I < 15)
	BEGIN
		PRINT 'VALOR DE @I = ' + CAST(@I AS VARCHAR)
		SET @I = @I + 1
	END
END
GO