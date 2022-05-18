# Adicionando valores na tabela
insert into pessoas
(nome, nascimento, sexo, peso, altura, nacionalidade)
values
('Lilian', '1987-07-29', 'F', '90', '1.65', 'Brasil'),
('Washington', '1995-03-04', 'M', '80', '2.05', 'Brasil'),
('Yasmin', '2018-02-25', 'F', '20', '1.03', 'Portugal'),
('Yuri', '2020-04-19', 'M', '15', '0.86', 'Portugal');

# Adicionando valores na tabela de outra forma
insert into pessoas values
('Joao', '1997-07-29', 'M', '90', '1.35');

# Acrescenta a coluna profissão em nossa tabela pessoas em ultima posição
alter table pessoas
add column profissao varchar (10);

# Elimina uma coluna, neste caso a coluna profissão
alter table pessoas
drop column profissao;

# Acrescenta a coluna profissão após a coluna nome
alter table pessoas
add column profissao varchar (10) after nome;

# Adiciona a coluna em primeira posição, antes de todas as colunas
alter table pessoas
add column codigo int first;

# Altera as caracteristicas da coluna, neste caso a coluna profissão de varchar de 10 para 20
alter table pessoas
modify column profissao varchar (20);

# Altera as caracteristicas da coluna, neste caso a coluna profissão tornandoa de preenchimento obigatorio
alter table pessoas
modify column profissao varchar (20) not null;

# Altera as caracteristicas da coluna, neste caso a coluna profissão tornandoa de preenchimento obigatorio com preenchimento vazio
alter table pessoas
modify column profissao varchar (20) not null default '';

# Altera o nome da coluna crarga para carga com obrigatoriedade de preenchimento e com preenchimento vazio
alter table cursos
change column crarga carga int (10) unsigned;

# Renomear toda a tabela de pessoas para gafanhotos
alter table pessoas
rename to gafanhotos;

# Adiciona a coluna idcurso na taleba cursos
alter table cursos
add column idcurso int first;

# Adiciona uma chave primaria na tabela cursos na coluna idcurso
alter table cursos
add primary key (idcurso);

# Adicionando valores na tabela cursos
insert into cursos values
('1','html5','curso de html5','40','37','2014'),
('2','algoritmos','logica de programação','20','15','2014'),
('3','photoshop','dicas de photoshop cc','10','8','2014'),
('4','php','curso de php para iniciantes','40','20','2010'),
('5','java','introdução a linguagem java','40','29','2016'),
('6','mysql','bancos de dados sql','30','15','2016'),
('7','word','curso completo de word','40','30','2016');

# Alterar o nome da linha 1 da tabela cursos de html4 para html5
update cursos
set nome = 'html5'
where idcurso = '1';

# Alterar o nome e ano da linha 4 da tabela cursos
update cursos
set nome = 'php', ano = '2015'
where idcurso = '4';

# Alterar o nome, carga e ano da linha 5 da tabela cursos
update cursos
set nome = 'java', carga = '40', ano = '2015'
where idcurso = '5'
limit 1; # Limita a quantidade de linhas a serem afetadas

# Faz o update de varias linhas dentro da tabela cursos que possuiam o ano de 2018
update cursos
set ano = '2050', carga = '800'
where ano = '2018';

# Deleta a linha da tabela cursos onde o id curso é 8
delete from cursos
where idcurso = 8;

# Deleta varias linhas da tabela que possuem o ano de 2050
delete from cursos
where ano = '2050'
limit 2;
