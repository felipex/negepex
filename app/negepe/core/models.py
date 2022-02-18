from django.db import models
from django.contrib import admin
from django.db.models import Value
from django.db.models.functions import Concat

from datetime import date, timedelta

class Unidade(models.Model):

    nome = models.CharField(max_length=100)
    sigla = models.CharField(max_length=50)
    codigo = models.CharField("código", max_length=60)
    umae = models.CharField("unidade mãe", max_length=60)

    @property
    @admin.display(
        ordering = Concat('umae', Value(' '), 'codigo'),
        description = 'caminho',
    )
    def nome_completo(self):
        return Unidade.objects.raw(f'select id, nomecompleto from vw_unidade where id = {self.id};')[0].nomecompleto

    def __str__(self):
        return f"{self.sigla} -  {self.nome}"


class Cargo(models.Model):
    
    GRUPO = (
        ("T", "Técnico-Administrativo"),
        ("D", "Docente"),
    )

    NIVEL = (
        ("C", "Fundamental"),
        ("D", "Médio"),
        ("E", "Superior"),
        ("X", "Docente"),
    )

    codigo = models.CharField("código", max_length=3)
    grupo = models.CharField(max_length=1, choices=GRUPO)
    nome = models.CharField(max_length=100)
    nivel = models.CharField("nível", max_length=1, choices=NIVEL)

    def __str__(self):
        return self.nome


class Servidor(models.Model):

    SEXO = (
        ("M", "Masculino"),
        ("F", "Feminino"),
    )

    COR = (
        ("0", "-"),
        ("1", "Branca"),
        ("3", "Amarela"),
        ("4", "Parda"),
        ("5", "Indígena"),
        ("6", "Preta"),
        ("9", "Não informada"),
    )

    LOCAL = (
        ("J", "Juazeiro do Norte"),
        ("B", "Barbalha"),
        ("C", "Crato"),
        ("S", "Brejo Santo"),
        ("M", "Multiuso"),
    )

    siape = models.CharField("SIAPE", unique=True, max_length=7)
    cpf = models.CharField("CPF", max_length=11)
    nome = models.CharField(max_length=70)
    sexo = models.CharField(max_length=1, choices=SEXO)
    cor = models.CharField("cor/Raça", max_length=1, choices=COR)
    email = models.EmailField("e-mail", max_length=125)
    local = models.CharField(max_length=1, choices=LOCAL)
    cargo = models.ForeignKey(Cargo, on_delete=models.PROTECT)
    dt_nasc = models.DateField("nascimento")
    ch = models.CharField("carga horária(h)", max_length=2, default="40")
    dt_exerc_sp = models.DateField("início do serviço púlbico")
    dt_desligamento = models.DateField("data de desligamento", null=True, blank=True)
    dt_inclusao = models.DateField("inclusão", null=False, blank=False, auto_now_add=True)

    @property
    def lotacao(self):
        return Lotacao.objects.filter(servidor=self).order_by('-dt_entrada').all()[0]

    lotacao.fget.short_description = "lotação"

    @property
    def funcao(self):
        f = Funcao.objects.filter(servidor=self).order_by('-dt_entrada').all()
        if (f):
            return f[0]
        else:
            return None
    funcao.fget.short_description = "função"
    
    @property
    def cpf_display(self):
        return self.cpf[0:3]+'.'+self.cpf[3:6]+'.'+self.cpf[6:9]+'-'+ self.cpf[9:11]
    cpf_display.fget.short_description = "CPF"


    ### O problema está sendo resolvido de forma meia-boca no admin.
    ### Mas vai servir por agora.
    def save_LIXO(self, *args, **kwargs):
        IS_INSERT = self.pk is None
        super(Servidor, self).save(*args, **kwargs)
        if (IS_INSERT):
            ### TO-DO: Essa amarração está muito feia. Seria bom criar uma configuração ou fazer logo a inclusão imediata da lotação.
            unidade = Unidade.objects.get(sigla='UFCA')
            l = Lotacao(
                servidor=self, 
                unidade=unidade, 
                dt_entrada=date.today()
            )
            l.save()
            

    class Meta:
        verbose_name_plural = "Servidores"


    def __str__(self):
        return self.nome


def get_default_lotacao():
    return Unidade.objects.get(sigla='UFCA')


class Lotacao(models.Model):
    servidor = models.ForeignKey(Servidor, on_delete=models.PROTECT)
    unidade = models.ForeignKey(Unidade, on_delete=models.PROTECT, default=get_default_lotacao)
    dt_entrada = models.DateField("data de entrada", default=date.today())
    dt_saida = models.DateField("data de saída", null=True, blank=True)
    dt_inclusao = models.DateField("inclusão", null=False, blank=False, auto_now_add=True)

    class Meta:
        verbose_name = "Lotação"
        verbose_name_plural = "Lotações"
        ordering = ['-dt_entrada']

    def __str__(self):
        return f"{self.unidade.sigla} - {self.unidade.nome}"

    def save(self, *args, **kwargs):
        print('->', self)
        if (self.pk is None):
            ult_lotacao = self.servidor.lotacao
            print('-->', ult_lotacao)
            if (ult_lotacao.dt_saida is None):
                dt_saida = self.dt_entrada - timedelta(days=1)
                ult_lotacao.dt_saida = dt_saida
                ult_lotacao.save()

        super(Lotacao, self).save(*args, **kwargs)


class Funcao(models.Model):
    CODIGO = (
        ("CD1", "CD 000.1"),
        ("CD2", "CD 000.2"),
        ("CD3", "CD 000.3"),
        ("CD4", "CD 000.4"),
        ("FG1", "FG 000.1"),
        ("FG2", "FG 000.2"),
        ("FG3", "FG 000.3"),
        ("FG4", "FG 000.4"),
        ("FUC1", "FUC 000.1"),
    )

    servidor = models.ForeignKey(Servidor, on_delete=models.PROTECT)
    unidade = models.ForeignKey(Unidade, on_delete=models.PROTECT)
    descricao = models.CharField("descrição", max_length=128)
    codigo = models.CharField("código", max_length=4, choices=CODIGO)
    dt_entrada = models.DateField("data de entrada")
    dt_saida = models.DateField("data de saída", null=True, blank=True)
    dt_inclusao = models.DateField("inclusão", null=False, blank=False, auto_now_add=True)

    def __str__(self):
        return self.descricao

    class Meta:
        verbose_name = "Função"
        verbose_name_plural = "Funções"


"""

insert into campus (nome) values ("Juazeiro do Norte");
insert into campus (nome) values ("Crato");
insert into campus (nome) values ("Barbalha");
insert into campus (nome) values ("Brejo Santo");


-----------------------------------
--- Tabela de código de função
-----------------------------------
drop table if exists codfuncao;
create table codfuncao (
   id serial primary key,
   codigo varchar(4) not null,
   nome varchar(30) not null
);

insert into codfuncao (codigo, nome) values ("CD1", "Cargo de Direção 1");
insert into codfuncao (codigo, nome) values ("CD2", "Cargo de Direção 2");
insert into codfuncao (codigo, nome) values ("CD3", "Cargo de Direção 3");
insert into codfuncao (codigo, nome) values ("CD4", "Cargo de Direção 4");
insert into codfuncao (codigo, nome) values ("FG1", "Função Gratificada 1");
insert into codfuncao (codigo, nome) values ("FG2", "Função Gratificada 2");
insert into codfuncao (codigo, nome) values ("FG3", "Função Gratificada 3");
insert into codfuncao (codigo, nome) values ("FG4", "Função Gratificada 4");
insert into codfuncao (codigo, nome) values ("FUC1","Coordernação de Curso");


-----------------------------------
--- Tabela de tipo de desligamento
-----------------------------------
drop table if exists tipodesligamento;
create table tipodesligamento (
   id serial primary key,
   nome varchar(20) not null
);

insert into tipodesligamento (nome) values ("Aposentadoria");
insert into tipodesligamento (nome) values ("Redistribuição");
insert into tipodesligamento (nome) values ("Vacância");
insert into tipodesligamento (nome) values ("Demissão");
insert into tipodesligamento (nome) values ("Exoneração");
insert into tipodesligamento (nome) values ("Exoneração a pedido");
insert into tipodesligamento (nome) values ("PDV");
insert into tipodesligamento (nome) values ("Remoção Judicial");



"""

