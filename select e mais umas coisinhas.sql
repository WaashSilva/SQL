# Retorna todos os valores da tabela pessoas
select * from pessoas
order by nome; # Ordena atravez da coluna nome

# Retorna todos os valores da tabela pessoas
select * from pessoas
order by nome desc; # Ordena atravez da coluna nome por ordem decrescente

# Retorna apenas as colunas nome, carga, ano da tabela cursos
select nome, carga, ano from cursos
order by nome, ano; # Ordena por nome e ano

# descreve como foi criada a tabela pessoas
describe pessoas;
desc pessoas;

# Retorna todos os valores onde tiver 2016 na coluna
select * from cursos
where ano = '2016'
order by nome;

# Retorna as colunas nome, descrição e carga onde constar 2016 na coluna ano
select nome, descricao, carga from cursos
where ano = '2016'
order by nome;

# Retorna as colunas nome, descrição e carga onde constar ano menor ou igual a 2016
select nome, descricao, carga from cursos
where ano <= '2016'
order by nome;

# Retorna todos os cursos diferentes de 2016
select nome, descricao, carga from cursos
where ano != '2016' # Não igual
order by nome;

# retorna todos os cursos diferentes de 2016
select nome, descricao, carga, ano from cursos
where ano <> '2016' # Diferente
order by ano, nome;

# Exibe todos os cursos entre 2014 e 2016
select nome, ano from cursos
where ano between '2014' and '2016'
order by ano desc, nome;

# Retorna os curson que serão ministrados nos anos de 2014, 2017,2018
select nome, ano from cursos
where ano in ('2014','2016','2018')
order by ano, nome;

# Retorna os cursos com carga maior que 35 e total de aulas menor que 30
select * from cursos
where carga > 35 and totaulas < 30 ;

# Seleciona todos os cursos com o nome de php ou PHP
select * from cursos
where nome = 'php' or 'PHP'
order by nome;

# Mostra todos os cursos que iniciam com a letra 'P' e são seguidos por qualquer coisa ou nada
select * from cursos
where nome like 'P%'
order by nome;

# Retorna todos os cursos que possuem a letra 'A' no meio ou no fim
select * from cursos
where nome like '%a'
order by nome;


# Retorna todos os cursos que possuem a letra 'A' 
select * from cursos
where nome like '%a%'
order by nome;

# Retorna todos os cursos que nao possuem a letra 'A' 
select * from cursos
where nome not like '%a%'
order by nome;

# Retorna todos os cursos que iniciem com as letras 'PH' e finalizem com 'P' 
select * from cursos
where nome like 'ph%p'
order by nome;

# Retorna todos os cursos que iniciem com as letras 'PH' a ant-penultima seja 'P' finalizando com qualquer character 
select * from cursos
where nome like 'ph%p_'
order by nome;

# Retorna todos os cursos que iniciem com as letras 'P' tenha algum caracter depois finalizando com 'P' 
select * from cursos
where nome like 'p_p%'
order by nome;

# Retorna todos os cursos que iniciem com as letras 'P' tenha algum caracter depois finalizando com 'P' 
select * from cursos
where nome like 'p_p%'
order by nome;

# Distinct serve para distinguir os campos dentro de uma coluna e nao os apresentar repetidamente
select distinct nacionalidade from gafanhotos
order by nacionalidade;

# conta quantos registros possue a tabela cursos
select count(*) from cursos;

# Seleciona quantos registros possuem a carga maior que 40
select count(*) from cursos
where carga > 40;

# Seleciona a maior carga dentro da tabela cursos
select max(carga) from cursos;

# Seleciona dentro do ano de 2016 o curso com maior quantidade de aulas
select max(totaulas) from cursos
where ano = '2016';

# Seleciona dentro do ano de 2016 o curso com menor quantidade de aulas
select min(totaulas) from cursos
where ano = '2016';

# Soma a quantidade de aulas ministradas em 2016
select sum(totaulas) from cursos
where ano = '2016';

# Mostra a media do total de aulas por cursos ministrados em 2016
select avg(totaulas) from cursos
where ano = '2016';

# seleciona a coluna carga e agrupa as linhas semelhantes
select count(carga), carga from cursos
group by carga;














