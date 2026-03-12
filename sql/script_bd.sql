---- Criando e conectanddo o banco de dados:
create schema if not exists GerenciadorDeAlunos;
set search_path to GerenciadorDeAlunos;

---- Limpeza(Para rodar o código)
drop table if exists aluno cascade;
drop table if exists curso cascade;
drop table if exists historico cascade;
drop table if exists pre_requisito cascade;
drop table if exists turma cascade;
drop table if exists registro_matricula cascade;
drop procedure if exists atualizar_historico_aluno(); -- Esse comando agora limpa as procedures criadas no script para permitir a execução correta do Script SQL
drop function if exists fn_verificar_vagas(); 
drop function if exists fn_adicionar_historico();
drop trigger if exists trg_verificar_vagas on registro_matricula;
drop trigger if exists trg_criar_historico_pos_matricula on registro_matricula;

---- Criando as tabelas
create table if not exists curso(
	cod_curso serial primary key,
	nome varchar(50) not null unique, --Chave UNIQUE para unicidade do nome do curso
	carga_horaria int not null
		constraint ck_ch_positiva
		check (carga_horaria >= 0), -- CHECK para carrga horária positiva
	ementa varchar (300)
);

create table if not exists pre_requisito(
	id_preRequisito serial not null,
	cod_curso serial not null,
	primary key(id_preRequisito, cod_curso),
	constraint fk_curso
		foreign key(cod_curso)
		references curso(cod_curso)
		on delete cascade, -- Manteve 'ON DELETE CASCADE' pois o pré requisito é diretamente ligado ao curso
	constraint fk_preRequisito
		foreign key(id_preRequisito)
		references curso(cod_curso)
		on delete cascade -- Manteve 'ON DELETE CASCADE' pois o pré requisito é diretamente ligado ao curso
);

create table if not exists turma (
	id serial primary key,
	semestre float not null
		constraint ck_semestre_positivo
		check (semestre >= 0), --CHECK para número do semestre positivo
	horarios varchar(100) not null,	
	vagas int not null
		constraint ck_vagas_positivo
		check (vagas >= 0), --CHECK para númerode vagas positivas
	local varchar(100),
	cod_curso serial not null,
	constraint fk_codCurso_turma 
		foreign key(cod_curso)
		references curso(cod_curso)
		on delete restrict -- Foi colocaddo o 'RESTRICT' para segurança de integridade. Uma vez que o curso é essencial ao estabelecimento da turma e portanto, enquanto houver uma turma com o curso, o curso deve existir.
);

create table if not exists aluno (
	num_matricula serial primary key,
	nome varchar(40) not null unique, --Chave UNIQUE para unicidade do nome do aluno
	email varchar(60) not null unique --Chave UNIQUE para unicidade do email
);

create table if not exists registro_matricula(
	id_registro_matricula serial primary key,
	id_turma serial not null,
	num_matricula serial not null,
	constraint fk_turma_registro_matricula
		foreign key(id_turma)
		references turma(id)
		on delete restrict, --Valor definido como restrict pois é preciso manter o registro da matrícula para constituir histórico.
	constraint fk_aluno_registro_matricula
		foreign key(num_matricula)
		references aluno(num_matricula)
		on delete restrict -- Valor definido como restrict pois é necessário o valor do número da matrícula para exsitência do aluno. Verifica-se que registro matrícula faz o vínculo entre o aluno e a turma, constituinddo um histórico
);

create table if not exists historico(
	id serial primary key,
	nota float not null
		constraint ck_nota_positivo
		check (nota >= 0 and nota <=10), --CHECK para verificar se a nota está no intervalo de 0 a 10
	frequencia float not null
		constraint ck_frequencia_positivo
		check (frequencia >=0 and frequencia <= 100), -- CHECK para validar a frequencência positiva e mnor do que 100
	status varchar(10) default 'CURSANDO' --Chave DEFAULT para cadastrar o aluno como cursando, caso não seja definido no momento do castrado do histórico
		constraint ch_faixa_status
		check (status in ('APROVADO', 'REPROVADO', 'CURSANDO')), --CHECK verificar se o status está dentro da faixa de valores aceita
	id_registro_matricula serial not null,
	constraint fk_historico_registro_matricula
		foreign key (id_registro_matricula)
		references registro_matricula(id_registro_matricula)
		on delete restrict -- Definido como restrict para manutenção da integridade. Mesmo após a conclusão do vínculo do aluno. Os sistemas mantem os registros históricos do egresso, e dessa maneira a exclusão da turma ou do aluno não deve apagar o histórico
);

-- ===============================
-- ETAPA 3 - PROJETO FINAL
-- Carga de dados (INSERTs)
-- ===============================

---- Criando Cursos ----
insert into curso (nome, carga_horaria, ementa) values ('Introdução a lógica de programação', 30, 'variáveis, operadores aritméticos, operadores relacionais, estrutura condicional, estrutura de repetição, funções');
insert into curso (nome, carga_horaria, ementa) values ('Programação Orientada a Objetos', 60, 'Classes, atributos, métodos, heranças, encapsulamento, polimorfismo');
insert into curso (nome, carga_horaria, ementa) values ('Banco de Dados', 45, 'Banco de dados relacionais, DDL, DML, DCL e TCL');

---- Criando Pré Requisitos----
insert into pre_requisito (id_prerequisito, cod_curso) values (1, 2);
insert into pre_requisito (id_prerequisito, cod_curso) values (1, 3);
insert into pre_requisito (id_prerequisito, cod_curso) values (2, 3);

---- Criando Turmas ----
insert into turma (semestre, horarios, vagas, local, cod_curso) values (2026.10, 'SEG: 7:30 às 10:30', 30, 'Rua das Laranjeiras, 451, Itapipoca, Ceará', 1);
insert into turma (semestre, horarios, vagas, local, cod_curso) values (2026.10, 'TER: 10:30 às 12:30', 30,null , 2);
insert into turma (semestre, horarios, vagas, local, cod_curso) values (2026.10, 'SEX: 7:00 às 11:45', 30, null, 3);

---- Criando Alunos ----
INSERT INTO aluno (nome, email) VALUES ('João da Silva', 'joaosilva@gmail.com');
INSERT INTO aluno (nome, email) VALUES ('Maria Fernandes', 'maria_fernandes@gmail.com');
INSERT INTO aluno (nome, email) VALUES ('Fausto Henrique Dantas', 'fausto_henDantas@gmail.com');
INSERT INTO aluno (nome, email) VALUES ('Carlos Eduardo Lima', 'carlos.lima@gmail.com');
INSERT INTO aluno (nome, email) VALUES ('Ana Beatriz Souza', 'ana.souza@gmail.com');
INSERT INTO aluno (nome, email) VALUES ('Rafael Mendes Costa', 'rafael.costa@gmail.com');
INSERT INTO aluno (nome, email) VALUES ('Juliana Pereira Alves', 'juliana.alves@gmail.com');
INSERT INTO aluno (nome, email) VALUES ('Lucas Gabriel Rocha', 'lucas.rocha@gmail.com');

---- Matriculando os alunos ----
insert into registro_matricula  (id_turma, num_matricula) values (3, 1);
insert into registro_matricula  (id_turma, num_matricula) values (3, 2);
insert into registro_matricula  (id_turma, num_matricula) values (2, 3);
insert into registro_matricula  (id_turma, num_matricula) values (2, 4);
insert into registro_matricula  (id_turma, num_matricula) values (3, 5);
insert into registro_matricula  (id_turma, num_matricula) values (3, 6);
insert into registro_matricula  (id_turma, num_matricula) values (2, 7);
insert into registro_matricula  (id_turma, num_matricula) values (2, 8);


---- Registrando histórico ----
insert into historico (nota, frequencia, status, id_registro_matricula) values (10.00, 90, 'APROVADO', 1);
insert into historico (nota, frequencia, status, id_registro_matricula) values (06.50, 90, 'REPROVADO', 2);
insert into historico (nota, frequencia, status, id_registro_matricula) values (7.50, 90, 'APROVADO', 3);
insert into historico (nota, frequencia, status, id_registro_matricula) values (4.80, 100, 'REPROVADO', 4);
insert into historico (nota, frequencia, status, id_registro_matricula) values (8.75, 81, 'APROVADO', 5);
insert into historico (nota, frequencia, status, id_registro_matricula) values (9.50, 70, 'REPROVADO', 6);
insert into historico (nota, frequencia, status, id_registro_matricula) values (9.00, 84, 'APROVADO', 7);
insert into historico (nota, frequencia, status, id_registro_matricula) values (8.00, 87, 'APROVADO', 8);


-- ===============================
-- Consultas (SELECT)
-- ===============================

-- Consulta 1: Consultando todos os alunos
select nome from aluno;

-- Consulta 2: Consultando os cursos caddastrados e exibindo por ordem da maior para a menor carga horária
select * from curso order by carga_horaria desc;

 -- Consulta 3: Consultando os cursos cadastrados e exibindo o código do curso que é pré requisito
select 
	c.cod_curso as codigo_curso,
	c.nome as nome,
	c.carga_horaria as carga_horario,
	c.ementa as ementa,
	pr.id_prerequisito as pre_requisito
from curso c
	left join pre_requisito pr 
	on c.cod_curso = pr.cod_curso;
 
 -- Consulta 4: Consultando os cursos que tenham mais de 15 vagas
 select
 	t.id as id,
 	t.vagas as vagas,
 	c.nome as nome
from turma t
join curso c 
on t.cod_curso = c.cod_curso 
where t.vagas >= 15;
	
-- Consulta 5: Consultando quais registros de matrículas foram aprovados com nota maior do que 8
select
	a.nome as nome,
	h.nota as nota,
	h.status as status,
	h.frequencia as frequencia
from aluno a 
join registro_matricula rm 
on rm.num_matricula = a.num_matricula 
join historico h 
on rm.id_registro_matricula = h.id_registro_matricula 
where h.nota > 8;

-- Consulta 6: Lista todos os alunos matriculados em cada curso
select 
	a.nome as aluno,
	c.nome as curso
from aluno a 
join registro_matricula rm 
on rm.num_matricula = a.num_matricula 
join turma t
on t.id = rm.id_turma 
join curso c 
on t.cod_curso = c.cod_curso;


-- ===============================
-- ETAPA 4 - PROJETO FINAL
-- Aplicação de Constraints e Regras de Integridade
-- Essa etapa foi atualizada na criação das tabelas. Cada atualização de constraint segue um comentário explicando a tomada de decisão!
-- ===============================

-- ===============================
-- ETAPA 5 - PROJETO FINAL
-- Aprimoramente de querys e criação de triggers, procedures e views.
-- VIEW
-- ===============================

create view vw_cursos_e_prequisitos as --Essa view lista todos os cursos e os id's dos seus pré requisitos
select -- Configuração do select padrão que a view vai executar
	c.cod_curso as codigo_curso,
	c.nome as nome,
	c.carga_horaria as carga_horaria,
	c.ementa as ementa,
	pr.id_prerequisito as pre_requisito
from curso c
	left join pre_requisito pr 
	on c.cod_curso = pr.cod_curso;
	
create view vw_alunos_matriculados as --Essa view lista todos os alunos, os cursos em que estão matriculados e seus respectivos numeros de matrícula na instituição
select -- Configuração do select padrão que a view vai executar
	a.nome as aluno,
	c.nome as curso,
	a.num_matricula as num_matricula
from aluno a
join registro_matricula rm
on rm.num_matricula = a.num_matricula
join turma t
on t.id = rm.id_turma
join curso c
on t.cod_curso = c.cod_curso;
	
-- ===============================
-- VIEW MATERIALIZADA
-- ===============================

create materialized view mv_totalAlunos_porCursos as -- Essa view materializada é útil para quantificação do total de alunos cadastrados por curso
select --Esse é o select regra que vai ser executado quando a view for chamada
	c.nome as curso,
	count(*) as total_de_alunos -- Essa linha de código vai contar a ocorrência de alunos matriculados em cada curso
from curso c 
join turma t 
on t.cod_curso = c.cod_curso 
join registro_matricula rm 
on rm.id_turma = t.id 
join aluno a 
on rm.num_matricula = a.num_matricula 
group by c.nome; --Aqui o banco vai agrupar os resultados por nome do curso.


create materialized view mv_alunos_notaveis as --Essa view materializada filtra quais alunos foram aprovados nos cursos com notas maiores do que 8
select --Esse é o select regra que vai ser executado quando a view for chamada
	a.nome as nome,
	h.nota as nota,
	h.status as status,
	h.frequencia as frequencia
from aluno a 
join registro_matricula rm 
on rm.num_matricula = a.num_matricula 
join historico h 
on rm.id_registro_matricula = h.id_registro_matricula 
where h.nota > 8;

-- ===============================
-- TRIGGERS
-- ===============================

--CREATE FUNCTION 
create function fn_verificar_vagas() --Essa função vai verificar a quantidade de vagas
returns trigger -- Ela retorna um trigger
language plpgsql
as $$
begin --Aqui começa o bloco
	if (select count(*) from gerenciadordealunos.registro_matricula where id_turma = NEW.id_turma) >= -- Faz um select e conta a quantidade de registros de matrícula para determinado id de turma
	(select vagas from gerenciadordealunos.turma where id = new.id_turma) then -- o operador >= verifica se essas contagem de vagas é superior a quantidade de vagas ofertadas no cadastro da turma
		raise exception 'A turma já atingiu o limite de vagas'; --Aqui lança uma exceção que não permite o ato de matrícula 
	end if;
	return new;
end;
$$;

create function fn_adicionar_historico()
returns trigger
language plpgsql
as $$
begin
	insert into gerenciadordealunos.historico (nota, frequencia, status, id_registro_matricula) values (0.00, 0, 'CURSANDO', NEW.id_registro_matricula);
	return new;
end;
$$;

--CREATE TRIGGER
create trigger trg_verificar_vagas -- esse bloco efetivamente criar o trigger 
before insert on gerenciadordealunos.registro_matricula -- Coloca uma insersção de before exatamente antes de fazer um registro matrícula, verificando autoamticamente se tem vaga no sistema.
for each row
execute function fn_verificar_vagas();

create trigger trg_criar_historico_pos_matricula
after insert on gerenciadordealunos.registro_matricula
for each row
execute function fn_adicionar_historico();

-- ===============================
-- PROCEDURE
-- ===============================

create procedure atualizar_historico_aluno() -- Procedure útil para atualização de status do aluno (APROVADO, REPROVADO, CURSANDO), 
--uma vez que o curso pode ter sido terminado e o sistema avalia sozinho se passou ou não. Ou então o professor promove alguma interferência no registro do aluno (como faltas justificadas)
language plpgsql --define a linguagem do bloco
as $$ -- inicia o bloco
begin 
	update gerenciadordealunos.historico -- Percorre a tabela histórico
	set status = -- altera o status conforme o case
		case 
			when nota >= 7 and frequencia >= 75 then 'APROVADO' -- lógica do case, aonde para franquência maior do que 75 e nota maior do que 7, o aluno é aprovado.
			else 'REPROVADO' -- Se não ele é reprovado.
		end;
end;
$$; -- termina o bloco

call atualizar_historico_aluno(); -- Executa a procedure















