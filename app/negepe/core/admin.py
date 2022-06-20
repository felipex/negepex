from django.contrib import admin
from django.utils.html import format_html

from .models import Unidade, Cargo, Lotacao, Funcao, Servidor

admin.site.disable_action('delete_selected')

@admin.register(Unidade)
class UnidadeAdmin(admin.ModelAdmin):
    list_display = ('sigla',  'nome', 'mae', 'codigo', 'nome_completo')
    list_display_links = ('sigla', 'nome')
    search_fields = ('sigla', 'nome', 'codigo', 'umae')
    list_per_page = 20


@admin.register(Cargo)
class CargoAdmin(admin.ModelAdmin):
    list_display = ('nome', 'nivel', 'grupo')
    search_fields = ('nome',)
    list_per_page = 20

    list_filter = ('nivel', 'grupo')


class LotacaoInline(admin.TabularInline):
    model = Lotacao
    extra = 0
    min_num = 1
    can_delete = False


class EhAtivo(admin.SimpleListFilter):
    title = 'Em atividade'
    parameter_name = 'dt_desligamento'

    def lookups(self, request, model_admin):
        return (
            ('Sim', 'Em atividade'),
            ('Nao', 'Desligado'),
        )

    def queryset(self, request, queryset):
        value = self.value()
        if value == 'Sim':
            return queryset.filter(dt_desligamento__isnull=True)
        elif value == 'Nao':
            return queryset.filter(dt_desligamento__isnull=False)

        return queryset


@admin.register(Servidor)
class ServidorAdmin(admin.ModelAdmin):
    list_display = ("acoes","ativo", "siape", "nome", "cpf_display", "cargo", "lotacao", "funcao")
    autocomplete_fields = ("cargo",)
    search_fields = ("siape", "nome", "cpf", "cargo__nome", "lotacao__unidade__nome", "lotacao__unidade__sigla")
    list_display_links = ("siape", "nome", "cpf_display")
    list_per_page = 20

    list_filter = ("local", "cargo__grupo", "cargo__nivel", "cor", EhAtivo)

    inlines = [LotacaoInline,]
  
    #def get_queryset(self, request):
    #    queryset = super().get_queryset(request)
    #    queryset = queryset.annotate(
    #        _ativo = Ra("")
    #    )

    def ativo(self, obj):
        return obj.ativo 
    
    ativo.admin_order_field = 'dt_desligamento'
    ativo.boolean = True


    def acoes(self, obj):
        view_name = "admin:{}_{}_change".format(obj._meta.app_label, obj._meta.model_name)
        link1 = f"https://www.portaltransparencia.gov.br/servidores/consulta?paginacaoSimples=true&tamanhoPagina=&offset=&direcaoOrdenacao=asc&cpf={obj.cpf}&colunasSelecionadas=detalhar%2Ctipo%2Cnome%2Csituacao%2Cfuncao%2Ccargo%2CunidadeOrganizacionalServidorLotacao%2Catividade%2Clicenca&t=M6rlYZUZSXukAsrGPAF0"

        html1 = f'<a target="_blank" href="{link1}"><svg xmlns="http://www.w3.org/2000/svg"  id="Layer_1" data-name="Layer 1" viewBox="0 0 24 24" width="20" height="20"><path d="M20,12a3.994,3.994,0,0,0-3.172,1.566l-.07-.03a5,5,0,0,0-6.009-6.377l-.091-.172A3.995,3.995,0,1,0,8.879,7.9l.073.137a4.992,4.992,0,0,0-1.134,6.7L5.933,16.5a4,4,0,1,0,1.455,1.377l1.838-1.718a4.993,4.993,0,0,0,6.539-.871l.279.119A4,4,0,1,0,20,12ZM6,4A2,2,0,1,1,8,6,2,2,0,0,1,6,4ZM4,22a2,2,0,1,1,2-2A2,2,0,0,1,4,22Zm8-7a3,3,0,0,1-1.6-5.534l.407-.217A3,3,0,1,1,12,15Zm8,3a2,2,0,1,1,2-2A2,2,0,0,1,20,18Z"/></svg></a>'

        link2 = f"https://www.portaltransparencia.gov.br/servidores/consulta?paginacaoSimples=true&tamanhoPagina=&offset=&direcaoOrdenacao=asc&cpf={obj.cpf}&colunasSelecionadas=detalhar%2Ctipo%2Cnome%2Csituacao%2Cfuncao%2Ccargo%2CunidadeOrganizacionalServidorLotacao%2Catividade%2Clicenca&t=M6rlYZUZSXukAsrGPAF0"

        html2 = f'<a target="_blank" href="{link2}"><svg xmlns="http://www.w3.org/2000/svg"  id="Layer_1" data-name="Layer 1" viewBox="0 0 24 24" width="20" height="20"><path d="M20,12a3.994,3.994,0,0,0-3.172,1.566l-.07-.03a5,5,0,0,0-6.009-6.377l-.091-.172A3.995,3.995,0,1,0,8.879,7.9l.073.137a4.992,4.992,0,0,0-1.134,6.7L5.933,16.5a4,4,0,1,0,1.455,1.377l1.838-1.718a4.993,4.993,0,0,0,6.539-.871l.279.119A4,4,0,1,0,20,12ZM6,4A2,2,0,1,1,8,6,2,2,0,0,1,6,4ZM4,22a2,2,0,1,1,2-2A2,2,0,0,1,4,22Zm8-7a3,3,0,0,1-1.6-5.534l.407-.217A3,3,0,1,1,12,15Zm8,3a2,2,0,1,1,2-2A2,2,0,0,1,20,18Z"/></svg></a>'
    
        return format_html(html1+html2)


    acoes.short_description = "- Ações -"


@admin.register(Lotacao)
class LotacaoAdmin(admin.ModelAdmin):
    list_display = ("unidade", "servidor", "dt_entrada")
    autocomplete_fields = ("unidade", "servidor",)
    search_fields = ("unidade__nome", "unidade__sigla", "servidor__nome")
    list_per_page = 20

    list_filter = ("unidade", "dt_entrada")
    ordering = ["servidor", "unidade", "-dt_entrada"]
    date_hierarchy = 'dt_entrada'


@admin.register(Funcao)
class FuncaoAdmin(admin.ModelAdmin):
    list_display = ("servidor", "codigo", "descricao", "unidade", "dt_entrada")
    autocomplete_fields = ("servidor", "unidade",)
    search_fields = ("unidade__nome", "unidade__sigla", "servidor__nome")
    list_per_page = 20

    list_filter = ("codigo", "dt_entrada")






