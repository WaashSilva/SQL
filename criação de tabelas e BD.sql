# Criar um banco de Dados
create database cadastro;

# Seleciona o Banco de Dados
use cadastro;

# Criar Tabelas
create table pessoas (
nome varchar (30),
nascimento tinyint (3),
sexo varchar (1),
peso float,
altura float,
nacionalidade varchar (20)
);

# Elimina o Banco de Dados 
drop database cadastro;

# Cria um banco de dados com padrão de Acentuação com padrão Portugues
create database cadastro
default character set utf8
default collate utf8_general_ci;

# Elimina a tabela pessoas
drop table pessoas;

# Criar uma tabela com padrão utf-8
create table pessoas (
nome varchar (30) not null, # Obriga o preenchimento da coluna
nascimento date,
sexo enum ('M','F'), # Define a obrigatoriedade de preenchimento de acordo com oque esta dentro do parenteses
peso decimal (5,2), # total de 5 numeros sendo 2 deles após a virgula, EX: 120,20
altura decimal (3,2),
nacionalidade varchar (20) default 'Brasil' # Se nao for preenchido, levara como padrão a nacionalidade Brasil
)default charset = utf8;


# Criar uma tabela com padrão utf-8 e com uma chave primaira e identificador
create table pessoas (
id int not null auto_increment, # Adiciona um indentificador para nao conter 2 registros semelhantes automatico
nome varchar (30) not null,
nascimento date,
sexo enum ('M','F'), 
peso decimal (5,2), 
altura decimal (3,2),
nacionalidade varchar (20) default 'Brasil',
primary key (id) # Indentifica qual a chave primaria
)default charset = utf8;

# Cria a tabela caso ela ainda nao exista no caso a tabela cursos
create table if not exists cursos (
nome varchar (30) not null unique, # nao permite dois cursos com o mesmo nome
descricao text,
crarga int unsigned, # Sem sinal logo nao pode ter carga negativa
totaulas int, 
ano year
) default charset = utf8;

# Apagar todos os registros da tabela cursos
truncate cursos;





































