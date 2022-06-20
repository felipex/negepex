drop table if exists cap_planilha;
create table cap_planilha (
	id serial,
	nome varchar(128), 
	sexo varchar(10),
	siape varchar(20),
	racacor varchar(100),
	cpf varchar(20),
	dt_nasc date,
	email varchar(128),
	cargo varchar(256),
	nivel char(1),
	campus varchar(128),
	unidade varchar(256),
	funcao varchar(256),
	cod_funcao varchar(10),
	ch varchar(2),
	dt_exercicio date
);

--- Executar essa parte pelo psl
docker cp tools/CAP_Controle_de_Pessoal.csv negepe_data:/home/CAP_Controle_de_Pessoal.csv

docker exec -i negepe_data psql -U postgres -d negepex -c "set datestyle to german; copy cap_planilha(nome, sexo, siape, racacor, cpf, dt_nasc, email, cargo, nivel, campus, unidade, funcao, cod_funcao, ch, dt_exercicio) from '/home/CAP_Controle_de_Pessoal.csv' delimiter ',' csv header"


-------
--- Ajuste a formatacao do CPF e SIAPE
update cap_planilha
set cpf = trim(regexp_replace(cpf, '\.|-', '', 'g')) 
where length(cpf) > 11;

update cap_planilha
set cpf = lpad(cpf, 11, '0')  
where length(cpf) < 11;

update cap_planilha
set siape = trim(siape);

update cap_planilha
set siape = lpad(siape, 7, '0')  
where length(siape) < 7;


------------------------------------------
--- Tabela de servidor
------------------------------------------
drop table if exists servidor;
create table servidor (
  id serial primary key,
  siape char(7) not null,
  cpf char(11) not null,
  sexo char(1) null,
  nome varchar(60) not null,
  cor char(2) null,
  dt_nasc date not null,
  email varchar(125) null,
  campus integer not null,
  unidade varchar(6) null,
  cargo integer not null,
  nivel char(1),
  ch char(2) not null,
  dt_exerc_sp date not null,
  dt_creation timestamp with time zone default current_timestamp
);

--update cap_planilha
--set cpf = replace(replace(trim(cpf), '.', ''), '-', '') 
--where length(cpf) > 11

insert into servidor 
      (siape, cpf, sexo, nome, dt_nasc, email, ch, dt_exerc_sp, campus, cargo, nivel)
select trim(siape), cpf, sexo, nome, dt_nasc, email, ch, dt_exercicio, 0, 0, nivel from cap_planilha
where cpf is not null;

--- Atualiza as FKs

-- Cor
update cap_planilha set racacor = 'AMARELA' where upper(racacor) = 'AMARELA';
update cap_planilha set racacor = 'BRANCA' where upper(racacor) = 'BRANCO';
update cap_planilha set racacor = 'PARDA' where upper(racacor) = 'PARDO';
update cap_planilha set racacor = 'NÃO INFORMADO' where upper(racacor) = 'DOCENTE NÃO QUIS DECLARAR COR/RAÇA';

update servidor
set cor = coalesce((select (select codigo from cor where upper(trim(descricao)) = upper(trim(cap_planilha.racacor)) ) from cap_planilha
where trim(cap_planilha.siape) = servidor.siape), '00')

-- Campus
update servidor
set campus = coalesce((select (select id from campus where upper(trim(nome)) = upper(trim(cap_planilha.campus))) from cap_planilha
where trim(cap_planilha.siape) = servidor.siape), 0)


-- Cargos
CREATE OR REPLACE FUNCTION sem_acento(p_texto text)  
  RETURNS text AS  
 $BODY$  
 Select translate($1,  
 'áàâãäåaaaÁÂÃÄÅAAAÀéèêëeeeeeEEEÉEEÈìíîïìiiiÌÍÎÏÌIIIóôõöoooòÒÓÔÕÖOOOùúûüuuuuÙÚÛÜUUUUçÇñÑýÝ',  
 'aaaaaaaaaAAAAAAAAAeeeeeeeeeEEEEEEEiiiiiiiiIIIIIIIIooooooooOOOOOOOOuuuuuuuuUUUUUUUUcCnNyY'   
  );  
 $BODY$  
 LANGUAGE sql VOLATILE  
 COST 100;  


update servidor
set cargo = coalesce((select (select id from cargo where sem_acento(upper(trim(nome))) = sem_acento(upper(trim(cap_planilha.cargo)))) from cap_planilha
where trim(cap_planilha.siape) = servidor.siape), 0);

---
--- Depois disso é preciso verificar quem o cargo 0 para atualizar na mão.
----
select cargo, count(*) from
(select s.siape, s.cargo as cargo0, cap.cargo as cargo from servidor s 
left join cap_planilha cap on trim(cap.siape) = s.siape
where s.cargo = 0) a
group by cargo
order by cargo;

update cap_planilha set cargo = 'ANALISTA DE TECNOLOGIA DA INFORMAÇÃO' where upper(cargo) like '%ANALISTA DE TEC DA INFORMACAO%';
update cap_planilha set cargo = 'ENFERMEIRO/ÁREA' where upper(cargo) like '%ENFERMEIRO-ARE%';
update cap_planilha set cargo = 'ENGENHEIRO/ÁREA' where upper(cargo) like '%ENGENHEIRO-AREA%';
update cap_planilha set cargo = 'MÉDICO/ÁREA' where upper(cargo) like '%MEDICO%';
update cap_planilha set cargo = 'MÉDICO/ÁREA' where upper(cargo) like '%MÉDICO-ÁREA%';
update cap_planilha set cargo = 'NUTRICIONISTA/HABILITAÇÃO' where upper(cargo) like '%NUTRICIONISTA%';
update cap_planilha set cargo = 'PEDAGOGO/ÁREA' where upper(cargo) like '%PEDAGOGO%';
update cap_planilha set cargo = 'PSICÓLOGO/ÁREA' where upper(cargo) like '%PSICOLO%';
update cap_planilha set cargo = 'TÉCNICO DE TECNOLOGIA DA INFORMAÇÃO' where upper(cargo) like '%TEC DE TECNOLOGIA%';
update cap_planilha set cargo = 'TÉCNICO EM ANATOMIA E NECROPSIA' where upper(cargo) like '%ANATOMIA%';
update cap_planilha set cargo = 'TÉCNICO EM ENFERMAGEM' where upper(cargo) like '%TECNICO DE ENFERMAGEM%';
update cap_planilha set cargo = 'TRADUTOR INTERPRETE DE LINGUAGEM SINAIS' where upper(cargo)  like '%SINAIS%';


-- REPETE O COMANDO
update servidor
set cargo = coalesce((select (select id from cargo where sem_acento(upper(trim(nome))) = sem_acento(upper(trim(cap_planilha.cargo)))) from cap_planilha
where trim(cap_planilha.siape) = servidor.siape), 0);

-- FUNÇÕES
drop table if exists funcao;
create table funcao (
	id serial primary key,
	siape char(7) not null,
	descricao varchar(128) not null, 
	codigo varchar(9) not null,
	unidade varchar(6) not null,
	dt_inicio date not null,
	dt_fim date null,
	dt_creation timestamp with time zone default current_timestamp
);

-- Os nome das unidades está muito fora do padrão. Não vai dar pra fazer
-- automaticamente
insert into funcao (siape, descricao, codigo, unidade, dt_inicio) 
select trim(siape), funcao, trim(cod_funcao),  '1000', now()
from cap_planilha where trim(upper(cod_funcao)) <> 'NÃO POSSUI';

-- Lotações
drop table if exists lotacao;
create table lotacao (
	id serial primary key,
	siape char(7) not null,
	unidade varchar(6) not null,
	dt_inicio date not null,
	dt_fim date null,
	dt_creation timestamp with time zone default current_timestamp
);

-- Os nome das unidades está muito fora do padrão. Não vai dar pra fazer
-- automaticamente
--insert into funcao (siape, descricao, codigo, unidade, dt_inicio) 
--select trim(siape), funcao, trim(cod_funcao),  '1000', now()
---from cap_planilha where trim(upper(cod_funcao)) <> 'NÃO POSSUI';


----
drop view if exists vw_servidor;
create view vw_servidor as
select 
     s.*, 
     coalesce(cargo.nome, '') as cargo_nome,
     coalesce(cor.descricao, '') as cor_nome,
     coalesce(campus.nome, '') as campus_nome, 
     coalesce(unidade.sigla, '') as unidade_sigla,
     coalesce(unidade.nome, '') as unidade_nome,
     coalesce(funcao.codigo, '') as funcao_codigo,
	 coalesce(funcao.descricao, '') as funcao_nome,
	 funcao.dt_inicio as funcao_inicio,
	 u.nome as funcao_unidade
from servidor s
     left join cargo on cargo.id = s.cargo
     left join campus on campus.id = s.campus
     left join unidade on unidade.id = s.unidade
     left join cor on cor.codigo = s.cor
	 left join funcao on funcao.siape = s.siape and dt_fim is null
	 left join unidade u on u.id = funcao.unidade;
	 
	insert into core_servidor (siape, cpf, nome, sexo, cor, email, local, cargo_id, dt_nasc, ch, dt_exerc_sp, dt_inclusao) select siape, cpf, nome, sexo, substring(cor,2,1), email, CASE WHEN campus = 1 THEN 'J' WHEN campus = 2 THEN 'C' WHEN campus =3 THEN 'B' WHEN campus=4 THEN 'S' ELSE 'J' END, CASE WHEN cargo = 0 THEN 286 ELSE cargo END, dt_nasc, ch, dt_exerc_sp, now() from servidor;


-- Todos para a lotação UFCA (id = 2)
insert into core_lotacao (servidor_id, unidade_id, dt_entrada, dt_inclusao)
select id, 2, '2013-06-05', now() from core_servidor;

-- Coloca as unidades que estão na planilha

-- View auxiliar
create view vw_lotas as select u.id as unidade_id, s.id as servidor_id from cap_planilha p, core_servidor s, core_unidade u where length(unidade) > 1 and s.siape = trim(p.siape) and u.sigla = p.unidade;

update core_lotacao set unidade_id = (select unidade_id from vw_lotas where vw_lotas.servidor_id = core_lotacao.servidor_id) where servidor_id in (select servidor_id from vw_lotas);


-- Funções
-- View auxiliar

insert into core_funcao (servidor_id, unidade_id, descricao, codigo, dt_entrada, dt_inclusao ) select s.id as servidor_id, 2 as unidade_id, descricao, 
	case 
		when codigo = 'FG 000.1' then 'FG1' 
		when codigo = 'FG 000.2' then 'FG2' 
		when codigo = 'FG 0002' then 'FG2' 
		when codigo = 'FG 000.3' then 'FG3' 
		when codigo = 'FG 000.4' then 'FG4' 
		when codigo = 'CD 000.1' then 'CD1' 
		when codigo = 'CD 000.2' then 'CD2' 
		when codigo = 'CD 000.3' then 'CD3' 
		when codigo = 'CD 000.4' then 'CD4' 
		when codigo = 'FUC 000.1' then 'FUC1' 
	end as codigo,
	'2013-06-05' as dt_entrada,
	now() as dt_inclusao
	from funcao f, core_servidor s where s.siape = f.siape;

