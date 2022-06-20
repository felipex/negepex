-----------------------------------
--- Tabela de cor/raça
-----------------------------------
drop table if exists cor;
create table cor (
	codigo char(2) not null primary key,
	descricao varchar(50) not null
);

insert into cor (codigo, descricao) values ('01', 'BRANCA');
insert into cor (codigo, descricao) values ('03', 'AMARELA');
insert into cor (codigo, descricao) values ('04', 'PARDA');
insert into cor (codigo, descricao) values ('05', 'INDIGENA');
insert into cor (codigo, descricao) values ('06', 'PRETA');
insert into cor (codigo, descricao) values ('09', 'NAO INFORMADO');
insert into cor (codigo, descricao) values ('00', '');


-----------------------------------
--- Tabela de campus
-----------------------------------
drop table if exists campus;
create table campus (
   id serial primary key,
   nome varchar(50) not null
);

insert into campus (nome) values ('Juazeiro do Norte');
insert into campus (nome) values ('Crato');
insert into campus (nome) values ('Barbalha');
insert into campus (nome) values ('Brejo Santo');


-----------------------------------
--- Tabela de código de função
-----------------------------------
drop table if exists codfuncao;
create table codfuncao (
   id serial primary key,
   codigo varchar(4) not null,
   nome varchar(30) not null
);

insert into codfuncao (codigo, nome) values ('CD1', 'Cargo de Direção 1');
insert into codfuncao (codigo, nome) values ('CD2', 'Cargo de Direção 2');
insert into codfuncao (codigo, nome) values ('CD3', 'Cargo de Direção 3');
insert into codfuncao (codigo, nome) values ('CD4', 'Cargo de Direção 4');
insert into codfuncao (codigo, nome) values ('FG1', 'Função Gratificada 1');
insert into codfuncao (codigo, nome) values ('FG2', 'Função Gratificada 2');
insert into codfuncao (codigo, nome) values ('FG3', 'Função Gratificada 3');
insert into codfuncao (codigo, nome) values ('FG4', 'Função Gratificada 4');
insert into codfuncao (codigo, nome) values ('FUC1','Coordernação de Curso');


-----------------------------------
--- Tabela de tipo de desligamento
-----------------------------------
drop table if exists tipodesligamento;
create table tipodesligamento (
   id serial primary key,
   nome varchar(20) not null
);

insert into tipodesligamento (nome) values ('Aposentadoria');
insert into tipodesligamento (nome) values ('Redistribuição');
insert into tipodesligamento (nome) values ('Vacância');
insert into tipodesligamento (nome) values ('Demissão');
insert into tipodesligamento (nome) values ('Exoneração');
insert into tipodesligamento (nome) values ('Exoneração a pedido');
insert into tipodesligamento (nome) values ('PDV');
insert into tipodesligamento (nome) values ('Remoção Judicial');



-----------------------------------
--- Tabela de unidade
-----------------------------------
drop table if exists unidade;
create table unidade (
  id varchar(6) not null primary key,
  nome varchar(100) not null,
  sigla varchar(50) not null,
  codigo varchar(6) not null,
  umae varchar(6)
);

drop view if exists vw_unidade;
create view vw_unidade as
select id, nome, codigo,
  CASE
    WHEN trisa is not null THEN concat(sigla, '/', mae, '/', avo, '/', bisa, '/', trisa)
    WHEN bisa is not null THEN concat(sigla, '/', mae, '/', avo, '/', bisa)
    WHEN avo is not null THEN concat(sigla, '/', mae, '/', avo)
    WHEN mae is not null THEN concat(sigla, '/', mae)
	ELSE sigla
  END as nomecompleto
from
(select s.id, s.nome, s.codigo, s.sigla, mae.sigla as mae, avo.sigla as avo, bisa.sigla as bisa, trisa.sigla as trisa
  from core_unidade s
  left join core_unidade mae   on s.umae = mae.codigo
  left join core_unidade avo   on mae.umae = avo.codigo
  left join core_unidade bisa  on avo.umae = bisa.codigo
  left join core_unidade trisa on bisa.umae = trisa.codigo
) a;


drop view if exists vw_unidade;
create view vw_unidade as
select id, nome,  
  CASE
    WHEN trisa is not null THEN concat(sigla, '/', mae, '/', avo, '/', bisa, '/', trisa)
    WHEN bisa is not null THEN concat(sigla, '/', mae, '/', avo, '/', bisa)
    WHEN avo is not null THEN concat(sigla, '/', mae, '/', avo)
    WHEN mae is not null THEN concat(sigla, '/', mae)
	ELSE sigla
  END as nomecompleto
from
(select s.id, s.nome, s.sigla, mae.sigla as mae, avo.sigla as avo, bisa.sigla as bisa, trisa.sigla as trisa
  from unidade s
  left join unidade mae   on s.umae = mae.id
  left join unidade avo   on mae.umae = avo.id
  left join unidade bisa  on avo.umae = bisa.id
  left join unidade trisa on bisa.umae = trisa.id
) a;


insert into unidade(id, nome, sigla, codigo, umae) values('1000', 'Universidade Federal do Cariri', 'UFCA', '122391', null);
insert into unidade(id, nome, sigla, codigo, umae) values('1001', 'Auditoria Interna', 'AUDIN', '228569', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1002', 'Departamentdo de Auditoria Orçamentária, Financeira, Patrimonial e Contabilidade', 'DAOFPC', '228572', '1001');
insert into unidade(id, nome, sigla, codigo, umae) values('1003', 'Departamento de Auditoria de Controle de Gestão de Pessoas', 'DACGP', '228570', '1001');
insert into unidade(id, nome, sigla, codigo, umae) values('1004', 'Departamento de Auditoria de Suprimentos, Bens e Serviços', 'DASBS', '265002', '1001');
insert into unidade(id, nome, sigla, codigo, umae) values('1005', 'Cerimonial e Apoio a Eventos', 'CEAPE', '228575', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1006', 'Divisão de Sonorização', 'DS', '238594', '1005');
insert into unidade(id, nome, sigla, codigo, umae) values('1007', 'Núcleo de Cerimonial', 'NC', '228577', '1005');
insert into unidade(id, nome, sigla, codigo, umae) values('1008', 'Diretoria de Articulação e Relações Institucionais', 'DIARI', '228598', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1009', 'Coordenadoria de Acompanhamento das Relações Institucionais', 'CARI', '228602', '1008');
insert into unidade(id, nome, sigla, codigo, umae) values('1010', 'Coordenadoria de Estágios e Desenvolvimento Profissional', 'CEDP', '228599', '1008');
insert into unidade(id, nome, sigla, codigo, umae) values('1011', 'Divisão da Central de Estágios', 'DCE', '254970', '1010');
insert into unidade(id, nome, sigla, codigo, umae) values('1012', 'Diretoria de Comunicação', 'DCOM', '228371', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1013', 'Coordenadoria de Conteúdo Institucional', 'CCI', '228374', '1012');
insert into unidade(id, nome, sigla, codigo, umae) values('1014', 'Divisão de Acessibilidade Informacional', 'DAI', '228374', '1013');
insert into unidade(id, nome, sigla, codigo, umae) values('1015', 'Divisão de Audio Visual', 'DAV', '228376', '1013');
insert into unidade(id, nome, sigla, codigo, umae) values('1016', 'Divisão de Relacionamento e Métricas de Audiência', 'DRMA', '228473', '1013');
insert into unidade(id, nome, sigla, codigo, umae) values('1017', 'Núcleo de Gestão', 'NG-DCOM', '238372', '1012');
insert into unidade(id, nome, sigla, codigo, umae) values('1018', 'Núcleo de Identidade Visual', 'NIV', '228373', '1012');
insert into unidade(id, nome, sigla, codigo, umae) values('1019', 'Diretoria de Infraestrutura', 'DINFRA', '228603', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1020', 'Coordenadoria de Estudos e Projetos de Arquitetura e Urbanismo', 'CEPAU', '228605', '1019');
insert into unidade(id, nome, sigla, codigo, umae) values('1021', 'Divisão de  Acessibilidade Física', 'DAF', '228606', '1021');
insert into unidade(id, nome, sigla, codigo, umae) values('1022', 'Coordenadoria de Gestão de Obras', 'CGO', '228608', '1019');
insert into unidade(id, nome, sigla, codigo, umae) values('1023', 'Divisão de Obras Civis', 'DOC', '228614', '1022');
insert into unidade(id, nome, sigla, codigo, umae) values('1024', 'Divisão de Obras Elétricas', 'DOE', '228607', '1022');
insert into unidade(id, nome, sigla, codigo, umae) values('1025', 'Coordenadoria de Manutenção', 'CMA', '228609', '1019');
insert into unidade(id, nome, sigla, codigo, umae) values('1026', 'Divisão de Aquisição e Manutenção de Equipamentos', 'DAME', '228610', '1025');
insert into unidade(id, nome, sigla, codigo, umae) values('1027', 'Divisão de Gerência do Sistema de Prevenção e Combate a Incêndio', 'DGSPCI', '228612', '1025');
insert into unidade(id, nome, sigla, codigo, umae) values('1028', 'Divisão de Manutenção Elétrica', 'DME', '228611', '1025');
insert into unidade(id, nome, sigla, codigo, umae) values('1029', 'Coordenadoria de Projetos Complementares e Licitação', 'CPCL', '228613', '1019');
insert into unidade(id, nome, sigla, codigo, umae) values('1030', 'Divisão de Eficiência Energética', 'DEE', '228615', '1029');
insert into unidade(id, nome, sigla, codigo, umae) values('1031', 'Divisão de Projetos Complementares', 'DPC', '228616', '1029');
insert into unidade(id, nome, sigla, codigo, umae) values('1032', 'Núcleo de Gestão', 'NG-DINFRA', '228604', '1019');
insert into unidade(id, nome, sigla, codigo, umae) values('1033', 'Diretoria de Logística e Apoio Operacional', 'DLA', '228377', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1034', 'Departamento de Contratos', 'DEPCON', '228378', '1033');
insert into unidade(id, nome, sigla, codigo, umae) values('1035', 'Departamento de Transportes', 'DEPTRAN', '228379', '1033');
insert into unidade(id, nome, sigla, codigo, umae) values('1036', 'Diretoria de Tecnologia da Informação', 'DTI', '228583', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1037', 'Coordenadoria de Gestão e Segurança da Informação', 'CGSI', '228585', '1036');
insert into unidade(id, nome, sigla, codigo, umae) values('1038', 'Divisão de Contratações e Contratos', 'DCC', '228587', '1037');
insert into unidade(id, nome, sigla, codigo, umae) values('1039', 'Divisão de Projetos, Processos e Segurança da Informação', 'DPSI', '228597', '1037');
insert into unidade(id, nome, sigla, codigo, umae) values('1040', 'Divisão de Serviços de TI', 'DSTI', '228586', '1037');
insert into unidade(id, nome, sigla, codigo, umae) values('1041', 'Coordenadoria de Infraestrutura de TI', 'CITI', '228588', '1036');
insert into unidade(id, nome, sigla, codigo, umae) values('1042', 'Divisão de Apoio Técnico de Tecnologia da Informação', 'DATI', '228589', '1041');
insert into unidade(id, nome, sigla, codigo, umae) values('1043', 'Divisão de Data Center', 'DDC', '228592', '1041');
insert into unidade(id, nome, sigla, codigo, umae) values('1044', 'Divisão de Redes e Telefonia', 'DRT', '228590', '1041');
insert into unidade(id, nome, sigla, codigo, umae) values('1045', 'Coordenadoria de Sistemas de Informação', 'CSI', '228593', '1036');
insert into unidade(id, nome, sigla, codigo, umae) values('1046', 'Divisão de Sistemas Administrativos', 'DSA', '228595', '1045');
insert into unidade(id, nome, sigla, codigo, umae) values('1047', 'Divisão de Sistemas de Ensino', 'DSE', '228594', '1045');
insert into unidade(id, nome, sigla, codigo, umae) values('1048', 'Seção de Operação dos Sistemas de Graduação', 'SOSG', '238738', '1047');
insert into unidade(id, nome, sigla, codigo, umae) values('1049', 'Divisão de Sistemas de Recursos Humanos', 'DSRH', '228596', '1045');
insert into unidade(id, nome, sigla, codigo, umae) values('1050', 'Núcleo de Gestão', 'NG-DTI', '228584', '1036');
insert into unidade(id, nome, sigla, codigo, umae) values('1051', 'Diretoria dos Sistemas de Bibliotecas', 'SIBI', '228519', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1052', 'Núcleo da Biblioteca do Campus Barbalha', 'BCB', '228523', '1051');
insert into unidade(id, nome, sigla, codigo, umae) values('1053', 'Núcleo da Biblioteca do Campus Brejo Santo', 'BCBS', '228521', '1051');
insert into unidade(id, nome, sigla, codigo, umae) values('1054', 'Núcleo da Biblioteca do Campus Crato', 'BCC', '228525', '1051');
insert into unidade(id, nome, sigla, codigo, umae) values('1055', 'Núcleo da Biblioteca do Campus de Icó', 'BCI', '228522', '1051');
insert into unidade(id, nome, sigla, codigo, umae) values('1056', 'Núcleo da Biblioteca do Campus do Juazeiro do Norte', 'BCJN', '228524', '1051');
insert into unidade(id, nome, sigla, codigo, umae) values('1057', 'Núcleo de Aquisição', 'NUAQ', '228520', '1051');
insert into unidade(id, nome, sigla, codigo, umae) values('1058', 'Gabinete da Reitoria', 'GR', '228565', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1059', 'Núcleo de Diárias e Passagens', 'NDP', '228568', '1058');
insert into unidade(id, nome, sigla, codigo, umae) values('1060', 'Núcleo de Gestão', 'NG-GR', '228566', '1058');
insert into unidade(id, nome, sigla, codigo, umae) values('1061', 'Núcleo de Projetos  Especiais em Inovação e Empreendedorismo', 'CRIE', '228567', '1058');
insert into unidade(id, nome, sigla, codigo, umae) values('1062', 'Ouvidoria Geral', 'OUVIDORIA', '228573', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1063', 'Núcleo de Gestão', 'NG-OUVIDORIA', '228574', '1062');
insert into unidade(id, nome, sigla, codigo, umae) values('1064', 'Procuradoria Geral', 'PROCURADORIA', '228470', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1065', 'Núcleo de Apoio Administrativo', 'NAA', '228471', '1064');
insert into unidade(id, nome, sigla, codigo, umae) values('1066', 'Pró-Reitoria de Administração', 'PROAD', '228448', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1067', 'Coordenadoria Apoio às Compras', 'CAC', '228449', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1068', 'Divisão de Planejamento e Controle de Compras', 'DPCC', '238748', '1067');
insert into unidade(id, nome, sigla, codigo, umae) values('1069', 'Coordenadoria Executiva', 'CEXEC', '228467', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1070', 'Divisão de Controle Orçamentário', 'DCO', '228403', '1069');
insert into unidade(id, nome, sigla, codigo, umae) values('1071', 'Coordenadoria de Contabilidade e Finanças', 'CCF', '228450', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1072', 'Divisão de Conformidade de Gestão', 'DCG', '228451', '1071');
insert into unidade(id, nome, sigla, codigo, umae) values('1073', 'Divisão de Contabilidade', 'DC', '228452', '1071');
insert into unidade(id, nome, sigla, codigo, umae) values('1074', 'Divisão de Execução Financeira', 'DEF', '228454', '1071');
insert into unidade(id, nome, sigla, codigo, umae) values('1075', 'Divisão de Execução Orçamentária', 'DEO', '228453', '1071');
insert into unidade(id, nome, sigla, codigo, umae) values('1076', 'Coordenadoria de Contratos', 'CCON', '228455', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1077', 'Divisão de Acompanhamento e Controle', 'DAC', '228457', '1076');
insert into unidade(id, nome, sigla, codigo, umae) values('1078', 'Divisão de Gestão de Atas de Registro de Preços', 'DGARP', '228456', '1076');
insert into unidade(id, nome, sigla, codigo, umae) values('1079', 'Divisão de Gestão de Contratos', 'DGC', '228458', '1076');
insert into unidade(id, nome, sigla, codigo, umae) values('1080', 'Coordenadoria de Fiscalização de Serviços Terceirizados', 'CTER', '228459', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1081', 'Divisão de Limpeza e Zeladoria', 'DLZ', '228447', '1080');
insert into unidade(id, nome, sigla, codigo, umae) values('1082', 'Coordenadoria de Licitações', 'CL', '228463', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1083', 'Divisão de Apoio Administrativo', 'DAA', '238749', '1082');
insert into unidade(id, nome, sigla, codigo, umae) values('1084', 'Coordenadoria de Materiais e Patrimônio', 'CMP', '228464', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1085', 'Divisão de Materiais', 'DMAT', '228466', '1084');
insert into unidade(id, nome, sigla, codigo, umae) values('1086', 'Divisão de Patrimônio', 'DP', '228465', '1084');
insert into unidade(id, nome, sigla, codigo, umae) values('1087', 'Núcleo de Apoio Legislativo', 'NALEGIS', '228469', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1088', 'Núcleo de Gestão', 'NG-PROAD', '228468', '1066');
insert into unidade(id, nome, sigla, codigo, umae) values('1089', 'Pró-Reitoria de Assuntos Estudantis', 'PRAE', '228414', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1090', 'Coordenadoria de Apoio ao Desenvolvimento Discente', 'CADD', '228416', '1089');
insert into unidade(id, nome, sigla, codigo, umae) values('1091', 'Divisão de Apoio Psicológico', 'DAPS', '263950', '1090');
insert into unidade(id, nome, sigla, codigo, umae) values('1092', 'Divisão de Apoio à Permanência', 'DAP', '228417', '1090');
insert into unidade(id, nome, sigla, codigo, umae) values('1093', 'Divisão de Atenção e Qualidade de Vida do Estudante', 'DAQVE', '228418', '1090');
insert into unidade(id, nome, sigla, codigo, umae) values('1094', 'Coordenadoria de Atenção e Integração Estudantil', 'CAIE', '228420', '1089');
insert into unidade(id, nome, sigla, codigo, umae) values('1095', 'Divisão de Serviço Social e Articulação Estudantil', 'DSSAE', '228422', '1094');
insert into unidade(id, nome, sigla, codigo, umae) values('1096', 'Coordenadoria do Refeitório Universitário', 'CRU', '228423', '1089');
insert into unidade(id, nome, sigla, codigo, umae) values('1097', 'Divisão de Apoio Financeiro', 'DAF', '228460', '1096');
insert into unidade(id, nome, sigla, codigo, umae) values('1098', 'Divisãao de Saúde e Nutrição', 'DSN', '228424', '1096');
insert into unidade(id, nome, sigla, codigo, umae) values('1099', 'Núcleo de Gestão', 'NG-PRAE', '228415', '1089');
insert into unidade(id, nome, sigla, codigo, umae) values('1100', 'Assessoria de Apoio Financeiro e Administrativo', 'AAFA', '269895', '1099');
insert into unidade(id, nome, sigla, codigo, umae) values('1101', 'Pró-Reitoria de Cultura', 'PROCULT', '228506', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1102', 'Coordenadoria de Artes', 'CARTES', '228509', '1101');
insert into unidade(id, nome, sigla, codigo, umae) values('1103', 'Divisão de Articulação Artística', 'DAAR', '228510', '1102');
insert into unidade(id, nome, sigla, codigo, umae) values('1104', 'Divisão de Formação Artística', 'DFAR', '228511', '1102');
insert into unidade(id, nome, sigla, codigo, umae) values('1105', 'Coordenadoria de Esporte e Cultura do Movimento', 'CECM', '228507', '1101');
insert into unidade(id, nome, sigla, codigo, umae) values('1106', 'Divisão de Projetos em Cultura do Movimento', 'DPCM', '228508', '1105');
insert into unidade(id, nome, sigla, codigo, umae) values('1107', 'Coordenadoria de Política e Diversidade Cultural', 'CPDC', '228512', '1101');
insert into unidade(id, nome, sigla, codigo, umae) values('1108', 'Divisão de Direitos Humanos e Combate às Opressões', 'DDHCO', '228387', '1107');
insert into unidade(id, nome, sigla, codigo, umae) values('1109', 'Divisão de Ensino, Pesquisa e Extensão', 'DEPE', '228513', '1107');
insert into unidade(id, nome, sigla, codigo, umae) values('1110', 'Divisão de Formento à Curricularização da Cultura', 'DFCC', '228501', '1107');
insert into unidade(id, nome, sigla, codigo, umae) values('1111', 'Núcleo de Comunicação', 'NUCOM', '228516', '1101');
insert into unidade(id, nome, sigla, codigo, umae) values('1112', 'Núcleo de Gestão', 'NG-PROCULT', '228515', '1101');
insert into unidade(id, nome, sigla, codigo, umae) values('1113', 'Núcleo de Idiomas e Culturas Estrangeiras', 'NUCLI', '228517', '1101');
insert into unidade(id, nome, sigla, codigo, umae) values('1114', 'Núcleo de Produção Cultural', 'NPC', '228518', '1101');
insert into unidade(id, nome, sigla, codigo, umae) values('1115', 'Pró-Reitoria de Extensão', 'PROEX', '228497', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1116', 'Coordenadoria de Gestão das Ações', 'CGA', '228498', '1115');
insert into unidade(id, nome, sigla, codigo, umae) values('1117', 'Divisão de Monitoramento e Sistema de Informações', 'DMSI', '228499', '1116');
insert into unidade(id, nome, sigla, codigo, umae) values('1118', 'Coordenadoria de Integraçao e Formento das Ações', 'CIFA', '118502', '1115');
insert into unidade(id, nome, sigla, codigo, umae) values('1119', 'Divisão de Formento', 'DF', '228503', '1118');
insert into unidade(id, nome, sigla, codigo, umae) values('1120', 'Divisão de Integração das Ações - Microrregião I', 'DIA-I', '243917', '1119');
insert into unidade(id, nome, sigla, codigo, umae) values('1121', 'Divisão de Integração das Ações - Microrregião II', 'DIA-II', '243918', '1119');
insert into unidade(id, nome, sigla, codigo, umae) values('1122', 'Divisão de Integração das Ações - Microrregião III', 'DIA-III', '263425', '1119');
insert into unidade(id, nome, sigla, codigo, umae) values('1123', 'Coordenadoria de Políticas Extensionistas', 'CPEX', '228500', '1115');
insert into unidade(id, nome, sigla, codigo, umae) values('1124', 'Divisão de Articulação de Extensão', 'DAE', '243922', '1123');
insert into unidade(id, nome, sigla, codigo, umae) values('1125', 'Núcleo de Apoio à Divulgação e à Difusão da Extensão', 'NADDE', '238740', '1115');
insert into unidade(id, nome, sigla, codigo, umae) values('1126', 'Núcleo de Gerenciamento de Dados', 'NGD', '228505', '1115');
insert into unidade(id, nome, sigla, codigo, umae) values('1127', 'Núcleo de Gestão', 'NG-PROEX', '228504', '1115');
insert into unidade(id, nome, sigla, codigo, umae) values('1128', 'Pró-Reitoria de Gestão de Pessoas', 'PROGEP', '228425', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1129', 'Coordenadoria de Administração de Pessoal', 'CAP', '228427', '1128');
insert into unidade(id, nome, sigla, codigo, umae) values('1130', 'Divisão de Acompanhamento Financeiro e Orçamentário', 'DAFO', '228428', '1129');
insert into unidade(id, nome, sigla, codigo, umae) values('1131', 'Divisão de Cadastro e Atendimento ao Servidor', 'DCAS', '228431', '1129');
insert into unidade(id, nome, sigla, codigo, umae) values('1132', 'Divisão de Controle de Cargos e Funções', 'DCCF', '228432', '1129');
insert into unidade(id, nome, sigla, codigo, umae) values('1133', 'Divisão de Controle de Vínculos', 'DCV', '269949', '1129');
insert into unidade(id, nome, sigla, codigo, umae) values('1134', 'Divisão de Gerenciamento e Análise de Processos', 'DGAP', '228429', '1129');
insert into unidade(id, nome, sigla, codigo, umae) values('1135', 'Divisão de Pagamento de Pessoal', 'DPP', '228430', '1129');
insert into unidade(id, nome, sigla, codigo, umae) values('1136', 'Seção de Controle Interno', 'SCIn', '266766', '1135');
insert into unidade(id, nome, sigla, codigo, umae) values('1137', 'Coordenadoria de Admissão e Dimensionamento', 'CAD', '228433', '1128');
insert into unidade(id, nome, sigla, codigo, umae) values('1138', 'Divisão de Admissão', 'DA', '228434', '1137');
insert into unidade(id, nome, sigla, codigo, umae) values('1139', 'Divisão de Análise de Provisão', 'DAP', '228435', '1137');
insert into unidade(id, nome, sigla, codigo, umae) values('1140', 'Divisão de Dimensionamento', 'DD', '228436', '1137');
insert into unidade(id, nome, sigla, codigo, umae) values('1141', 'Divisão de Processo Seletivo', 'DPS', '228437', '1137');
insert into unidade(id, nome, sigla, codigo, umae) values('1142', 'Seção de Concurso Público', 'SCP', '238741', '1141');
insert into unidade(id, nome, sigla, codigo, umae) values('1143', 'Seção de Processo Seletivo Simplificado', 'SPSS', '238741', '1141');
insert into unidade(id, nome, sigla, codigo, umae) values('1144', 'Coordenadoria de Desenvolvimento Pessoal', 'CDP', '238741', '1128');
insert into unidade(id, nome, sigla, codigo, umae) values('1145', 'Divisão de Capacitação', 'DCAP', '228442', '1144');
insert into unidade(id, nome, sigla, codigo, umae) values('1146', 'Divisão de Gestão Pedagógica', 'DGP', '228600', '1144');
insert into unidade(id, nome, sigla, codigo, umae) values('1147', 'Divisão de Gestão de Carreiras', 'DGC', '228441', '1144');
insert into unidade(id, nome, sigla, codigo, umae) values('1148', 'Seção de Análise e Controle de Processos', 'SACP', '238745', '1147');
insert into unidade(id, nome, sigla, codigo, umae) values('1149', 'Divisão de Gestão de Desempenho', 'DGD', '228440', '1144');
insert into unidade(id, nome, sigla, codigo, umae) values('1150', 'Seção de Orientação e Acompanhamento de Desempenho', 'SOAD', '238744', '1149');
insert into unidade(id, nome, sigla, codigo, umae) values('1151', 'Coordenadoria de Legislação de Pessoal', 'CLP', '228426', '1128');
insert into unidade(id, nome, sigla, codigo, umae) values('1152', 'Coordenadoria de Qualidade de Vida no Trabalho', 'CQVT', '228443', '1128');
insert into unidade(id, nome, sigla, codigo, umae) values('1153', 'Divisão de Apoio Administrativo', 'DApAdm', '268030', '1152');
insert into unidade(id, nome, sigla, codigo, umae) values('1154', 'Divisão de Atenção à Saúde do Servidor', 'DASS', '228439', '1152');
insert into unidade(id, nome, sigla, codigo, umae) values('1155', 'Divisão de Estudo e Avaliação da Saúde do Servidor', 'DEASS', '228444', '1152');
insert into unidade(id, nome, sigla, codigo, umae) values('1156', 'Núcleo de Gestão', 'NG-PROGEP', '228446', '1128');
insert into unidade(id, nome, sigla, codigo, umae) values('1157', 'Núcleo de Perícias e Segurança no Trabalho', 'NPST', '228545', '1128');
insert into unidade(id, nome, sigla, codigo, umae) values('1158', 'Pró-Reitoria de Graduação', 'PROGRAD', '228546', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1159', 'Coordenadoria de Controle Acadêmico', 'CCA', '228547', '1158');
insert into unidade(id, nome, sigla, codigo, umae) values('1160', 'Divisão de Admissão', 'DADM', '228548', '1159');
insert into unidade(id, nome, sigla, codigo, umae) values('1161', 'Divisão de Diploma', 'DD', '228549', '1159');
insert into unidade(id, nome, sigla, codigo, umae) values('1162', 'Divisão de Fluxo Acadêmico', 'DFA', '228550', '1159');
insert into unidade(id, nome, sigla, codigo, umae) values('1163', 'Coordenadoria de Ensino e Graduação', 'CEG', '228551', '1158');
insert into unidade(id, nome, sigla, codigo, umae) values('1164', 'Divisão de Avaliação e Acompanhamento Acadêmica', 'DAAA', '228552', '1163');
insert into unidade(id, nome, sigla, codigo, umae) values('1165', 'Divisão de Diagnóstico e Acompanhamento dos Cursos de Graduação', 'DDACG', '228560', '1163');
insert into unidade(id, nome, sigla, codigo, umae) values('1166', 'Divisão de Implantação e Reformulação Curricular', 'DIRC', '228553', '1163');
insert into unidade(id, nome, sigla, codigo, umae) values('1167', 'Coordenadoria de Gestão de Dados Acadêmicos', 'CGDA', '228554', '1158');
insert into unidade(id, nome, sigla, codigo, umae) values('1168', 'Divisão de Estatística', 'DEST', '228555', '1167');
insert into unidade(id, nome, sigla, codigo, umae) values('1169', 'Divisão de Tratamento e Divulgação de Dados Acadêmicos', 'TDDADOS', '228556', '1167');
insert into unidade(id, nome, sigla, codigo, umae) values('1170', 'Coordenadoria para Fortalecimento da Qualidade do Ensino', 'CFOR', '228557', '1158');
insert into unidade(id, nome, sigla, codigo, umae) values('1171', 'Divisão de Aperfeiçoamento de Ensino-Aprendizagem', 'DAEA', '228558', '1170');
insert into unidade(id, nome, sigla, codigo, umae) values('1172', 'Divisão de Aproximação com Ensino Médio', 'DAEM', '255434', '1170');
insert into unidade(id, nome, sigla, codigo, umae) values('1173', 'Divisão de Programas Acadêmicos', 'DPA', '228559', '1170');
insert into unidade(id, nome, sigla, codigo, umae) values('1174', 'Núcleo de Apoio Pedagógico', 'NAP', '228562', '1158');
insert into unidade(id, nome, sigla, codigo, umae) values('1175', 'Núcleo De Educação a Distância', 'NEAD', '261320', '1158');
insert into unidade(id, nome, sigla, codigo, umae) values('1176', 'Núcleo de Gestão', 'NG-PROEN', '228563', '1158');
insert into unidade(id, nome, sigla, codigo, umae) values('1177', 'Procuradoria Educacional Institucional', 'PEI', '228561', '1158');
insert into unidade(id, nome, sigla, codigo, umae) values('1178', 'Pró-Reitoria de Pesquisa, Pós-Graduação e Inovação', 'PRPI', '228380', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1179', 'Coordenadoria de Editoração e Apoio a Publicações', 'CEAP', '228391', '1178');
insert into unidade(id, nome, sigla, codigo, umae) values('1180', 'Divisão de Revisão', 'DREV', '228392', '1179');
insert into unidade(id, nome, sigla, codigo, umae) values('1181', 'Coordenadoria de Inovação', 'CI', '228385', '1178');
insert into unidade(id, nome, sigla, codigo, umae) values('1182', 'Coordenadoria de Pesquisa', 'CP', '228381', '1178');
insert into unidade(id, nome, sigla, codigo, umae) values('1183', 'Divisão de Projetos e Grupos de Pesquisa', 'DPGP', '228382', '1182');
insert into unidade(id, nome, sigla, codigo, umae) values('1184', 'Coordenadoria de Pós-Graduação', 'CPG', '228388', '1178');
insert into unidade(id, nome, sigla, codigo, umae) values('1185', 'Divisão de Apoio aos Programas de Pós-Graduação - Lato Sensu', 'DAPPGLS', '228390', '1184');
insert into unidade(id, nome, sigla, codigo, umae) values('1186', 'Divisão de Apoio aos Programas de Pós-Graduação - Stricto Sensu', 'DAPPGSS', '228389', '1184');
insert into unidade(id, nome, sigla, codigo, umae) values('1187', 'Núcleo de Dados', 'ND', '228393', '1178');
insert into unidade(id, nome, sigla, codigo, umae) values('1188', 'Núcleo de Divulgação Científica', 'NDC', '228395', '1178');
insert into unidade(id, nome, sigla, codigo, umae) values('1189', 'Núcleo de Gestão', 'NG-PRPI', '228394', '1178');
insert into unidade(id, nome, sigla, codigo, umae) values('1190', 'Pró-Reitoria de Planejamento e Orçamento', 'PROPLAN', '228396', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1191', 'Coordenadoria de Gestão de Projetos e Processos', 'CGPP', '228407', '1190');
insert into unidade(id, nome, sigla, codigo, umae) values('1192', 'Divisão de Projetos', 'DPROJ', '228398', '1191');
insert into unidade(id, nome, sigla, codigo, umae) values('1193', 'Coordenadoria de Gestão de Sustentabilidade', 'CGS', '228408', '1190');
insert into unidade(id, nome, sigla, codigo, umae) values('1194', 'Divisão de Logística e Projetos Sustentáveis', 'DLPS', '228409', '1193');
insert into unidade(id, nome, sigla, codigo, umae) values('1195', 'Coordenadoria de Informação, Monitoramento e Avaliação Institucional', 'CIMAI', '228397', '1190');
insert into unidade(id, nome, sigla, codigo, umae) values('1196', 'Divisão de Informação e Formento', 'DIF', '228399', '1195');
insert into unidade(id, nome, sigla, codigo, umae) values('9195', 'Coordenadoria de Planejamento Orçamentário', 'CPO', '228402', '1190');
insert into unidade(id, nome, sigla, codigo, umae) values('9196', 'Divisão de Informação e Formento', 'DIF', '228399', '1195');
insert into unidade(id, nome, sigla, codigo, umae) values('1197', 'Coordenadoria de Planejamento Orçamentário', 'CPO', '228402', '1190');
insert into unidade(id, nome, sigla, codigo, umae) values('1198', 'Divisão de Controle Orçamentário', 'DCO', '228531', '1197');
insert into unidade(id, nome, sigla, codigo, umae) values('1199', 'Coordenadoria de Planejamento e Gestão Estratégica', 'CPGE', '228410', '1190');
insert into unidade(id, nome, sigla, codigo, umae) values('1200', 'Divisão de Gestão Estratégica', 'DGE', '228400', '1199');
insert into unidade(id, nome, sigla, codigo, umae) values('1201', 'Divisão de Planejamento', 'DPLAN', '228411', '1199');
insert into unidade(id, nome, sigla, codigo, umae) values('1202', 'Coordenadoria de Transparência, Governança e Gestão de Riscos', 'CTGR', '228404', '1190');
insert into unidade(id, nome, sigla, codigo, umae) values('1203', 'Divisão de Governança', 'DGOV', '228405', '1202');
insert into unidade(id, nome, sigla, codigo, umae) values('1204', 'Divisão de Transparência', 'DTR', '228406', '1202');
insert into unidade(id, nome, sigla, codigo, umae) values('1205', 'Secretaria de Acessibilidade', 'SEACE', '228618', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1206', 'Divisão de Atendimento e Articulação', 'DAA', '228620', '1205');
insert into unidade(id, nome, sigla, codigo, umae) values('1207', 'Núcleo de Gestão', 'NG-SEACE', '273469', '1206');
insert into unidade(id, nome, sigla, codigo, umae) values('1208', 'Divisão de Serviços Acessíveis', 'DSA', '228621', '1205');
insert into unidade(id, nome, sigla, codigo, umae) values('1209', 'Secretaria de Cooperação Internacional', 'SCI', '228472', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1210', 'Secretaria de Documentação e Protocolo', 'SEDOP', '228578', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1211', 'Divisão de Movimentação de Expediente', 'DME', '228579', '1210');
insert into unidade(id, nome, sigla, codigo, umae) values('1212', 'Secretaria de Processos Disciplinares e Comissões Permanentes', 'SEPAD', '228474', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1213', 'Divisão de Apoio e Acompanhamento das Comissões Permanentes', 'DCP', '244141', '1212');
insert into unidade(id, nome, sigla, codigo, umae) values('1214', 'Secretaria dos Órgãos Deliberativos Superiores', 'SEODS', '228412', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1215', 'Núcleo de Gestão', 'NG-SEODS', '228413', '1214');
insert into unidade(id, nome, sigla, codigo, umae) values('1216', 'Centro de Ciências Agrárias e da Biodiversidade', 'CCAB', '228527', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1217', 'Coordenação do Curso de Agronomia', 'AGRONOMIA', '228528', '1216');
insert into unidade(id, nome, sigla, codigo, umae) values('1218', 'Seção de Apoio Administrativo', 'SSA-AGRONOMIA', '238580', '1217');
insert into unidade(id, nome, sigla, codigo, umae) values('1219', 'Coordenação do Curso de Medicina Veterinária', 'MEDVET', '228532', '1216');
insert into unidade(id, nome, sigla, codigo, umae) values('1220', 'Seção de Apoio Administrativo', 'SAA-MEDVET', '255438', '1219');
insert into unidade(id, nome, sigla, codigo, umae) values('1221', 'Coordenação do Curso de Mestrado em Desenvolvimento Regional Sustentável', 'PRODER', '228529', '1216');
insert into unidade(id, nome, sigla, codigo, umae) values('1222', 'Núcleo de Gestão Sustentável', 'NGS', '228530', '1216');
insert into unidade(id, nome, sigla, codigo, umae) values('1223', 'Centro de Ciências Sociais Aplicadas', 'CCSA', '228476', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1224', 'Coordenação do Curso de Administração', 'ADM', '228478', '1223');
insert into unidade(id, nome, sigla, codigo, umae) values('1225', 'Seção de Apoio Administrativo', 'SSA-ADM', '238597', '1224');
insert into unidade(id, nome, sigla, codigo, umae) values('1226', 'Coordenação do Curso de Administração Pública', 'ADMPUB', '209839', '1223');
insert into unidade(id, nome, sigla, codigo, umae) values('1227', 'Seção de Apoio Administrativo', 'SSA-ADMPUBLICA', '238599', '1226');
insert into unidade(id, nome, sigla, codigo, umae) values('1228', 'Coordenação do Curso de Biblioteconomia', 'BIBL', '228480', '1223');
insert into unidade(id, nome, sigla, codigo, umae) values('1229', 'Seção de Apoio Administrativo', 'SSA-BIBLIOTECONOMIA', '238600', '1228');
insert into unidade(id, nome, sigla, codigo, umae) values('1230', 'Coordenação do Curso de Ciências Contábeis', 'CONTABEIS', '228479', '1223');
insert into unidade(id, nome, sigla, codigo, umae) values('1231', 'Seçõ de Apoio Administrativo', 'SSA-CONTABEIS', '263954', '1230');
insert into unidade(id, nome, sigla, codigo, umae) values('1232', 'Coordenação do Curso de Mestrado em Biblioteconomia', 'MBIBL', '228481', '1223');
insert into unidade(id, nome, sigla, codigo, umae) values('1233', 'Núcleo de Gestão', 'NG-CCSA', '228477', '1223');
insert into unidade(id, nome, sigla, codigo, umae) values('1234', 'Centro de Ciências e Tecnologia', 'CCT', '228533', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1235', 'Coordenação do Curso de Ciência da Computação', 'COMPUTAÇÂO', '228539', '1234');
insert into unidade(id, nome, sigla, codigo, umae) values('1236', 'Coordenação do Cruso de Engenharia Civil', 'ENGCIVIL', '228534', '1234');
insert into unidade(id, nome, sigla, codigo, umae) values('1237', 'Seção de Apoio Administrativo', 'SSA-ENGCIVIL', '238601', '1236');
insert into unidade(id, nome, sigla, codigo, umae) values('1238', 'Coordenação do Curso de Engenharia de Materiais', 'ENGMAT', '209838', '1234');
insert into unidade(id, nome, sigla, codigo, umae) values('1239', 'Seção de Apoio Administrativo', 'SAA-ENGMAT', '244132', '1238');
insert into unidade(id, nome, sigla, codigo, umae) values('1240', 'Coordenação do Curso de Matemática Computacional', 'MATCOMP', '228538', '1234');
insert into unidade(id, nome, sigla, codigo, umae) values('1241', 'Coordenação do Curso de Mestrado Profissional em Matemática', 'PROFMAT', '228537', '1234');
insert into unidade(id, nome, sigla, codigo, umae) values('1242', 'Núcleo de Gestão', 'NG-CCT', '228535', '1234');
insert into unidade(id, nome, sigla, codigo, umae) values('1243', 'Faculdade de Medicina', 'FAMED', '228540', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1244', 'Ambulatório de Especialidades Médicas', 'AEM', '238750', '1243');
insert into unidade(id, nome, sigla, codigo, umae) values('1245', 'Coordenação do Curso de Medicina', 'MED', '209841', '1243');
insert into unidade(id, nome, sigla, codigo, umae) values('1246', 'Seção de Apoio Administrativo', 'SSA-MEDICINA', '238598', '1245');
insert into unidade(id, nome, sigla, codigo, umae) values('1247', 'Coordenação do Curso de Mestrado Multicênico da Área de Bioquímica e Biologia Molecular', 'PMBqBM', '228544', '1243');
insert into unidade(id, nome, sigla, codigo, umae) values('1248', 'Coordenação do Curso de Mestrado em Ciências da Saúde', 'CCMCS', '228489', '1243');
insert into unidade(id, nome, sigla, codigo, umae) values('1249', 'Núcleo de Apoio a Estágios', 'NAES', '228541', '1243');
insert into unidade(id, nome, sigla, codigo, umae) values('1250', 'Núcleo de Gestão', 'NG-FAMED', '228542', '1243');
insert into unidade(id, nome, sigla, codigo, umae) values('1251', 'Núcleo de Pós-Graduação', 'NPG', '228543', '1243');
insert into unidade(id, nome, sigla, codigo, umae) values('1252', 'Instituto Interdisciplinar de Sociedade, Cultura e Arte', 'IISCA', '228492', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1253', 'Coordenação do Curso de Bacharelado em Design', 'DESIGN-BAC', '228495', '1252');
insert into unidade(id, nome, sigla, codigo, umae) values('1254', 'Coordenação do Curso de Bacharelado em Filosofia', 'FILOSOFIA-BAC', '218906', '1252');
insert into unidade(id, nome, sigla, codigo, umae) values('1255', 'Seção de Apoio Administrativo', 'SSA-FILOSOFIA', '238604', '1254');
insert into unidade(id, nome, sigla, codigo, umae) values('1256', 'Coordenação do Curso de Design de Produto', 'DESIGN', '209837', '1252');
insert into unidade(id, nome, sigla, codigo, umae) values('1257', 'Seção de Apoio Administrativo', 'SSA-DESIGN', '238603', '1256');
insert into unidade(id, nome, sigla, codigo, umae) values('1258', 'Coordenação do Curso de Jornalismo', 'JORNALISMO', '209836', '1252');
insert into unidade(id, nome, sigla, codigo, umae) values('1259', 'Seção de Apoio Administrativo', 'SSA-JORNALISMO', '238605', '1258');
insert into unidade(id, nome, sigla, codigo, umae) values('1260', 'Coordenação do Curso de Letras/Libras', 'LETRAS-LIBRAS', '228496', '1252');
insert into unidade(id, nome, sigla, codigo, umae) values('1261', 'Seção de Apoio Administrativo', 'SAA-LIBRAS', '238606', '1260');
insert into unidade(id, nome, sigla, codigo, umae) values('1262', 'Coordenação do Curso de Licenciatura em Filosofia', 'FILOSOFIA-LIC', '218905', '1252');
insert into unidade(id, nome, sigla, codigo, umae) values('1263', 'Coordenação do Curso de Música', 'MUSICA', '228494', '1252');
insert into unidade(id, nome, sigla, codigo, umae) values('1264', 'Seção de Apoio Administrativo', 'SAA-MUSICA', '238607', '1263');
insert into unidade(id, nome, sigla, codigo, umae) values('1265', 'Núcleo de Gestão', 'NG-IISCA', '228493', '1252');
insert into unidade(id, nome, sigla, codigo, umae) values('1266', 'Instituto de Formação de Educadores', 'IFE', '228485', '1000');
insert into unidade(id, nome, sigla, codigo, umae) values('1267', 'Coordenação do Curso de Biologia', 'BIOLOGIA', '228488', '1266');
insert into unidade(id, nome, sigla, codigo, umae) values('1268', 'Coordenação do Curso de Física', 'FISICA', '228486', '1266');
insert into unidade(id, nome, sigla, codigo, umae) values('1269', 'Coordenação do Curso de Licenciatura Interdisciplinar em Ciências Naturais e Matemática', 'INTEDISCIPLINAR', '228490', '1266');
insert into unidade(id, nome, sigla, codigo, umae) values('1270', 'Seção de Apoio Administrativo', 'SSA-INTERDISCIPLINAR', '238602', '1269');
insert into unidade(id, nome, sigla, codigo, umae) values('1271', 'Coordenação do Curso de Matemática', 'MAT', '228491', '1266');
insert into unidade(id, nome, sigla, codigo, umae) values('1272', 'Coordenação do Curso de Pedagogia', 'PEDAGOGIA', '244138', '1266');


-----------------------------------
--- Tabela de cargo
-----------------------------------
drop table if exists cargo;
create table cargo (
  id SERIAL NOT NULL PRIMARY KEY,
  codigo char(3) NOT NULL,
  grupo char(3) NOT NULL,
  nome varchar(100) NOT NULL,
  nivel char(1) NULL
);

 insert into cargo (codigo, grupo, nome, nivel) values ('406', '701', 'ADERECISTA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('001', '701', 'ADMINISTRADOR', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('400', '701', 'ADMINISTRADOR DE EDIFÍCIOS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('401', '701', 'AFINADOR DE INST MUSICAIS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('407', '701', 'ALMOXARIFE', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('062', '701', 'ANALISTA DE TECNOLOGIA DA INFORMAÇÃO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('002', '701', 'ANTROPÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('603', '701', 'ARMADOR', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('003', '701', 'ARQUEÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('004', '701', 'ARQUITETO E URBANISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('005', '701', 'ARQUIVISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('605', '701', 'ARRAIS', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('402', '701', 'ASCENSORISTA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('404', '701', 'ASSIST DE TECNOLOGIA DA INFORMAÇÃO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('403', '701', 'ASSISTENTE DE ALUNO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('607', '701', 'ASSISTENTE DE CÂMERA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('201', '701', 'ASSISTENTE DE DIREÇÃO E PRODUÇÃO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('817', '701', 'ASSISTENTE DE ESTUDOS', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('437', '701', 'ASSISTENTE DE LABORATÓRIO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('608', '701', 'ASSISTENTE DE MONTAGEM', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('606', '701', 'ASSISTENTE DE SOM', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('200', '701', 'ASSISTENTE EM ADMINISTRAÇÃO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('006', '701', 'ASSISTENTE SOCIAL', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('007', '701', 'ASSISTENTE TEC DE EMBARCAÇÕES', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('008', '701', 'ASTRÔNOMO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('609', '701', 'ATENDENTE DE CONSULTÓRIO/ÁREA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('610', '701', 'ATENDENTE DE ENFERMAGEM', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('009', '701', 'AUDITOR', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('611', '701', 'AUXILIAR DE AGROPECUÁRIA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('803', '701', 'AUXILIAR DE ALFAIATE', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('612', '701', 'AUXILIAR DE ANATOMIA E NECROPSIA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('657', '701', 'AUXILIAR DE ARTES GRÁFICAS', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('409', '701', 'AUXILIAR DE BIBLIOTECA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('613', '701', 'AUXILIAR DE CENOGRAFIA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('410', '701', 'AUXILIAR DE CRECHE', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('411', '701', 'AUXILIAR DE ENFERMAGEM', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('475', '701', 'AUXILIAR DE ENFERMAGEM - 30 HORAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('807', '701', 'AUXILIAR DE ESTOFADOR', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('617', '701', 'AUXILIAR DE FARMÁCIA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('808', '701', 'AUXILIAR DE FORJADOR DE METAIS', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('809', '701', 'AUXILIAR DE FUNDIÇÃO DE METAIS', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('656', '701', 'AUXILIAR DE IND E CONSERV DE ALIMENTOS', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('619', '701', 'AUXILIAR DE LABORATÓRIO', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('621', '701', 'AUXILIAR DE METEOROLOGIA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('622', '701', 'AUXILIAR DE MICROFILMAGEM', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('623', '701', 'AUXILIAR DE NUTRIÇÃO E DIETÉTICA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('814', '701', 'AUXILIAR DE SAPATEIRO', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('412', '701', 'AUXILIAR DE SAÚDE', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('413', '701', 'AUXILIAR DE TOPOGRAFIA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('414', '701', 'AUXILIAR DE VETERINÁRIA E ZOOTECNIA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('405', '701', 'AUXILIAR EM ADMINISTRAÇÃO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('408', '701', 'AUXILIAR EM ASSUNTOS EDUCACIONAIS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('801', '701', 'AUXILIAR RURAL', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('626', '701', 'BARQUEIRO', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('010', '701', 'BIBLIOTECÁRIO-DOCUMENTALISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('011', '701', 'BIÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('012', '701', 'BIOMÉDICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('415', '701', 'BRIGADISTA DE INCÊNDIO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('416', '701', 'CAMAREIRO DE ESPETÁCULO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('818', '701', 'CARVOEJADOR', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('042', '701', 'CENÓGRAFO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('417', '701', 'CENOTÉCNICO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('013', '701', 'COMANDANTE DE LANCHA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('014', '701', 'COMANDANTE DE NAVIO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('419', '701', 'CONDUTOR MOTORISTA FLUVIAL', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('202', '701', 'CONFECCIONADOR DE INST MUSICAIS', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('630', '701', 'CONSERVADOR DE PESCADO', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('015', '701', 'CONTADOR', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('421', '701', 'CONTINUO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('418', '701', 'CONTRA REGRA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('631', '701', 'CONTRAMESTRE FLUVIAL-MARÍTIMO', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('423', '701', 'CONTRAMESTRE-OFÍCIO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('016', '701', 'COREÓGRAFO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('420', '701', 'COSTUREIRO DE ESPETÁCULO-CENÁRIO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('422', '701', 'COZINHEIRO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('424', '701', 'COZINHEIRO DE EMBARCAÇÕES', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('425', '701', 'DATILÓGRAFO DE TEXTOS GRÁFICOS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('017', '701', 'DECORADOR', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('634', '701', 'DESENHISTA COPISTA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('204', '701', 'DESENHISTA DE ARTES GRÁFICAS', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('018', '701', 'DESENHISTA INDUSTRIAL', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('270', '701', 'DESENHISTA TÉCNICO ESPECIALIZADO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('203', '701', 'DESENHISTA-PROJETISTA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('468', '701', 'DETONADOR', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('205', '701', 'DIAGRAMADOR', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('019', '701', 'DIRETOR DE ARTES CÊNICAS', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('020', '701', 'DIRETOR DE FOTOGRAFIA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('021', '701', 'DIRETOR DE ILUMINAÇÃO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('022', '701', 'DIRETOR DE IMAGEM', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('023', '701', 'DIRETOR DE PRODUÇÃO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('024', '701', 'DIRETOR DE PROGRAMA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('025', '701', 'DIRETOR DE SOM', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('426', '701', 'DISCOTECÁRIO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('026', '701', 'ECONOMISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('027', '701', 'ECONOMISTA DOMÉSTICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('206', '701', 'EDITOR DE IMAGENS', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('028', '701', 'EDITOR DE PUBLICAÇÕES', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('427', '701', 'ELETRICISTA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('635', '701', 'ELETRICISTA DE EMBARCAÇÃO', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('428', '701', 'ELETRICISTA DE ESPETÁCULO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('429', '701', 'ENCADERNADOR', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('430', '701', 'ENCANADOR BOMBEIRO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('030', '701', 'ENFERMEIRO DO TRABALHO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('029', '701', 'ENFERMEIRO/ÁREA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('086', '701', 'ENGENHEIRO AGRÔNOMO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('032', '701', 'ENGENHEIRO DE SEGURANÇA DO TRABALHO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('031', '701', 'ENGENHEIRO/ÁREA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('033', '701', 'ESTATÍSTICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('087', '701', 'FARMACÊUTICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('088', '701', 'FARMACÊUTICO BIOQUÍMICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('034', '701', 'FARMACÊUTICO/HABILITAÇÃO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('035', '701', 'FIGURINISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('036', '701', 'FILOSOFO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('037', '701', 'FÍSICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('038', '701', 'FISIOTERAPEUTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('039', '701', 'FONOAUDIÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('431', '701', 'FOTOGRAFO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('432', '701', 'FOTOGRAVADOR', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('040', '701', 'GEÓGRAFO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('041', '701', 'GEÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('433', '701', 'GUARDA FLORESTAL', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('434', '701', 'HIALOTÉCNICO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('043', '701', 'HISTORIADOR', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('044', '701', 'IMEDIATO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('435', '701', 'IMPOSITOR', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('436', '701', 'IMPRESSOR', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('207', '701', 'INSTRUMENTADOR CIRÚRGICO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('045', '701', 'JORNALISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('438', '701', 'LINOTIPISTA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('439', '701', 'LOCUTOR', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('476', '701', 'LOCUTOR 25 HORAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('444', '701', 'MAQUINISTA DE ARTES CÊNICAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('469', '701', 'MARINHEIRO DE MAQUINAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('642', '701', 'MARINHEIRO FLUVIAL', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('470', '701', 'MARINHEIRO FLUVIAL DE MAQUINAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('440', '701', 'MATEIRO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('046', '701', 'MATEMÁTICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('441', '701', 'MECÂNICO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('271', '701', 'MECÂNICO APOIO MARÍTIMA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('443', '701', 'MECÂNICO DE MONTAGEM E MANUTENÇÃO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('048', '701', 'MEDICO VETERINÁRIO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('047', '701', 'MÉDICO/ÁREA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('208', '701', 'MESTRE DE EDIFICAÇÕES E INFRAESTRUTURA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('442', '701', 'MESTRE DE EMBARCAÇÕES DE PEQUENO PORTE', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('644', '701', 'MESTRE DE REDES', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('049', '701', 'MESTRE FLUVIAL', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('050', '701', 'MESTRE REGIONAL', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('051', '701', 'METEOROLOGISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('209', '701', 'MONTADOR CINEMATOGRÁFICO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('646', '701', 'MONTADOR-SOLDADOR', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('445', '701', 'MOTORISTA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('052', '701', 'MUSEÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('053', '701', 'MUSICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('054', '701', 'MÚSICO-TERAPEUTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('055', '701', 'NUTRICIONISTA/HABILITAÇÃO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('056', '701', 'OCEANÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('064', '701', 'ODONTÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('063', '701', 'ODONTÓLOGO -  DL 1445-76', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('446', '701', 'OPERADOR DE CALDEIRA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('210', '701', 'OPERADOR DE CÂMERA DE CINEMA E TV', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('447', '701', 'OPERADOR DE CENTRAL HIDRELÉTRICA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('448', '701', 'OPERADOR DE DESTILARIA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('449', '701', 'OPERADOR DE ESTAÇÃO DE TRATAMENTO DE  ÁUA E ECSGOT', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('451', '701', 'OPERADOR DE LUZ', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('454', '701', 'OPERADOR DE MAQUINA COPIADORA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('452', '701', 'OPERADOR DE MÁQUINAS AGRÍCOLAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('453', '701', 'OPERADOR DE MÁQUINAS DE CONSTRUÇÃO CIVI', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('455', '701', 'OPERADOR DE MÁQUINAS DE TERRAPLANAGEM', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('450', '701', 'OPERADOR DE MÁQUINAS FOTOCOMPOSITORAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('456', '701', 'OPERADOR DE RADIO TELECOMUNICAÇÕES', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('647', '701', 'OPERADOR DE TELE-IMPRESSORA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('057', '701', 'ORTOPTISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('058', '701', 'PEDAGOGO/ÁREA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('822', '701', 'PESCADOR PROFISSIONAL', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('651', '701', 'PINTOR DE CONSTRUÇÃO CÊNICA E PAINÉIS', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('458', '701', 'PORTEIRO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('059', '701', 'PRIMEIRO CONDUTOR', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('061', '701', 'PRODUTOR CULTURAL', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('457', '701', 'PROGRAMADOR DE RADIO E TELEVISÃO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('066', '701', 'PROGRAMADOR VISUAL', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('060', '701', 'PSICÓLOGO/ÁREA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('067', '701', 'PUBLICITÁRIO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('068', '701', 'QUÍMICO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('459', '701', 'RECEPCIONISTA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('212', '701', 'RECREACIONISTA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('069', '701', 'REDATOR', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('829', '701', 'REDEIRO', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('070', '701', 'REGENTE', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('072', '701', 'RELAÇÕES PUBLICAS', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('071', '701', 'RESTAURADOR/ÁREA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('460', '701', 'REVISOR DE PROVAS TIPOGRÁFICAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('073', '701', 'REVISOR DE TEXTOS', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('211', '701', 'REVISOR DE TEXTOS BRAILLE', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('074', '701', 'ROTEIRISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('461', '701', 'SALVA-VIDAS', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('075', '701', 'SANITARISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('652', '701', 'SAPATEIRO', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('076', '701', 'SECRETARIO EXECUTIVO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('471', '701', 'SEGUNDO CONDUTOR', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('653', '701', 'SELEIRO', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('462', '701', 'SERINGUEIRO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('077', '701', 'SOCIÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('463', '701', 'SONOPLASTA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('825', '701', 'TAIFEIRO FLUVIAL', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('826', '701', 'TAIFEIRO MARÍTIMO', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('219', '701', 'TAXIDERMISTA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('473', '701', 'TÉCNICO DE LABORATÓRIO - DEC JUDICIAL', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('472', '701', 'TÉCNICO DE LABORATÓRIO - DL 1445-76', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('244', '701', 'TÉCNICO DE LABORATÓRIO ÁREA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('226', '701', 'TÉCNICO DE TECNOLOGIA DA INFORMAÇÃO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('078', '701', 'TÉCNICO DESPORTIVO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('218', '701', 'TÉCNICO EM AEROFOTOGRAMETRIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('213', '701', 'TÉCNICO EM AGRIMENSURA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('214', '701', 'TÉCNICO EM AGROPECUÁRIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('215', '701', 'TÉCNICO EM ALIMENTOS E LATICÍNIOS', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('220', '701', 'TÉCNICO EM ANATOMIA E NECROPSIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('216', '701', 'TÉCNICO EM ARQUIVO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('217', '701', 'TÉCNICO EM ARTES GRÁFICAS', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('079', '701', 'TÉCNICO EM ASSUNTOS EDUCACIONAIS', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('221', '701', 'TÉCNICO EM AUDIOVISUAL', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('222', '701', 'TÉCNICO EM CARTOGRAFIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('223', '701', 'TÉCNICO EM CINEMATOGRAFIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('224', '701', 'TÉCNICO EM CONTABILIDADE', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('225', '701', 'TÉCNICO EM CURTUME E TANAGEM', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('227', '701', 'TÉCNICO EM ECONOMIA DOMESTICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('228', '701', 'TÉCNICO EM EDIFICAÇÕES', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('229', '701', 'TÉCNICO EM EDUCAÇÃO FÍSICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('272', '701', 'TÉCNICO EM ELETRICIDADE', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('232', '701', 'TÉCNICO EM ELETROELETRÔNICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('231', '701', 'TÉCNICO EM ELETROMECÂNICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('830', '701', 'TÉCNICO EM ELETRÔNICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('230', '701', 'TÉCNICO EM ELETROTÉCNICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('233', '701', 'TÉCNICO EM ENFERMAGEM', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('234', '701', 'TÉCNICO EM ENFERMAGEM DO TRABALHO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('235', '701', 'TÉCNICO EM ENOLOGIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('237', '701', 'TÉCNICO EM EQUIPAMENTO MÉDICO-ODONTOLÓICO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('273', '701', 'TÉCNICO EM ESTATÍSTICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('236', '701', 'TÉCNICO EM ESTRADAS', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('238', '701', 'TÉCNICO EM FARMÁCIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('239', '701', 'TÉCNICO EM GEOLOGIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('240', '701', 'TÉCNICO EM HERBÁRIO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('242', '701', 'TÉCNICO EM HIDROLOGIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('241', '701', 'TÉCNICO EM HIGIENE DENTAL', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('243', '701', 'TÉCNICO EM INSTRUMENTAÇÃO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('274', '701', 'TÉCNICO EM MANUTENÇÃO DE ÁUDIO VÍDEO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('245', '701', 'TÉCNICO EM MECÂNICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('246', '701', 'TÉCNICO EM METALURGIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('247', '701', 'TÉCNICO EM METEOROLOGIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('248', '701', 'TÉCNICO EM MICROFILMAGEM', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('249', '701', 'TÉCNICO EM MINERAÇÃO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('250', '701', 'TÉCNICO EM MOVEIS E ESQUADRIAS', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('251', '701', 'TÉCNICO EM MUSICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('252', '701', 'TÉCNICO EM NUTRIÇÃO E DIETÉTICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('253', '701', 'TÉCNICO EM ORTOPTICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('254', '701', 'TÉCNICO EM ÓTICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('255', '701', 'TÉCNICO EM PRÓTESE DENTARIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('256', '701', 'TÉCNICO EM QUÍMICA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('257', '701', 'TÉCNICO EM RADIOLOGIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('258', '701', 'TÉCNICO EM REABILITAÇÃO OU FISIOTERAPIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('259', '701', 'TÉCNICO EM REFRIGERAÇÃO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('260', '701', 'TÉCNICO EM RESTAURAÇÃO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('261', '701', 'TÉCNICO EM SANEAMENTO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('275', '701', 'TÉCNICO EM SECRETARIADO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('262', '701', 'TÉCNICO EM SEGURANÇA DO TRABALHO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('263', '701', 'TÉCNICO EM SOM', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('264', '701', 'TÉCNICO EM TELECOMUNICAÇÃO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('265', '701', 'TÉCNICO EM TELEFONIA', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('080', '701', 'TECNÓLOGO EM COOPERATIVISMO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('081', '701', 'TECNÓLOGO-FORMAÇÃO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('464', '701', 'TELEFONISTA', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('474', '701', 'TELEFONISTA - DECISÃO JUDICIAL', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('083', '701', 'TEÓLOGO', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('082', '701', 'TERAPEUTA OCUPACIONAL', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('465', '701', 'TIPÓGRAFO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('466', '701', 'TORNEIRO MECÂNICO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('084', '701', 'TRADUTOR INTERPRETE', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('266', '701', 'TRADUTOR INTERPRETE DE LINGUAGEM SINAIS', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('267', '701', 'TRANSCRITOR DE SISTEMA BRAILLE', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('654', '701', 'TRATORISTA', 'B');
 insert into cargo (codigo, grupo, nome, nivel) values ('827', '701', 'VESTIARISTA', 'A');
 insert into cargo (codigo, grupo, nome, nivel) values ('467', '701', 'VIDREIRO', 'C');
 insert into cargo (codigo, grupo, nome, nivel) values ('269', '701', 'VIGILANTE', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('268', '701', 'VISITADOR SANITÁRIO', 'D');
 insert into cargo (codigo, grupo, nome, nivel) values ('085', '701', 'ZOOTECNISTA', 'E');
 insert into cargo (codigo, grupo, nome, nivel) values ('001', '705', 'PROFESSOR DO MAGISTERIO SUPERIOR', 'X');

insert into core_cargo (id, codigo, nome, nivel, grupo)
select id, codigo, nome, nivel,    
  CASE
    WHEN grupo = '701' THEN 'T'
	ELSE 'D'
  END as grupo
from cargo;

delete from core_cargo where nivel in ('A', 'B');

