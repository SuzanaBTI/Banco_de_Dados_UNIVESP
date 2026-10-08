DROP DATABASE univesp_db;
create database if not exists univesp_db;
use univesp_db;

-- Criando a tabela que as outras FKs dependem
create table if not exists evento_academico (
id_evento int auto_increment primary key,
nome varchar(150) not null,
sigla varchar(20) not null
);

-- Inserindo o Evento Academico obrigatorio com ID 1
insert into evento_academico (id_evento, nome, sigla)
values (1, 'Simposio de Tecnologia da Univesp', 'STU')
on duplicate key update id_evento=1;

create table autor (
cpf varchar(11) primary key,
nome varchar(150) not null,
titulo_academico varchar(50) not null,
email varchar(100) not null
);
 
 create table artigo_cientifico (
 id_artigo int auto_increment primary key,
 titulo varchar(250) not null,
 palavras_chave varchar(200) not null,
 id_evento int not null,
 foreign key (id_evento) references evento_academico(id_evento)
 );
 
 create table artigo_autor (
 id_artigo int,
 cpf_autor varchar(11),
 primary key (id_artigo, cpf_autor),
 foreign key (id_artigo) references artigo_cientifico(id_artigo),
 foreign key (cpf_autor) references autor(cpf)
 );
 
 insert into autor (cpf, nome, titulo_academico, email) values
 ('11122233344', 'Carlos Silva', 'Doutor', 'carlos.silva@univesp.br'),
 ('55566677788', 'Ana Santos', 'Mestre', 'ana.santos@univesp.br');
 
 insert into artigo_cientifico (titulo, palavras_chave, id_evento) values
 ('Otimizacao de Performance com indices SQL', 'SQL, Performance, Index', 1),
 ('Analise de Pipelines de Agregacao no MongoDB', 'NoSQL, MongoDB. Big Data', 1);
 
 insert into artigo_autor (id_artigo, cpf_autor) values 
 (1, '11122233344'),
 (2, '11122233344'),
 (2, '55566677788');
 
 select
 e. sigla as Evento,
 ac. titulo as Titulo_Artigo,
 group_concat(a.nome separator',') AS Autores
 from artigo_cientifico ac
 inner join evento_academico e on ac.id_evento = e.id_evento
 inner join artigo_autor aa on ac.id_artigo = aa.id_artigo
 inner join autor a on aa.cpf_autor = a.cpf
 group by ac.id_artigo, e.sigla;
 
