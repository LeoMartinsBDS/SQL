/*Criando um bd - Delimitador*/

Create database aula_sql;

use aula_sql;

create table teste(
	nome varchar(30)
);

/*PROCESSAMENTO ASSINCRONO

GO -> QUEBRA INSTRUCOES SQL EM PACOTES FISICOS
	  SQL Server é mais utilizado o GO em relação ao ';'
	  Sem o GO, o comando irá escolher a instrução que demanda menos processamento
*/

Create database aula_sql01
go

use aula_sql01
go

create table teste(
	nome varchar(30)
)
go