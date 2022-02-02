from django.contrib import admin

from .models import Unidade, Cargo, Lotacao, Funcao, Servidor

admin.site.disable_action('delete_selected')

@admin.register(Unidade)
class UnidadeAdmin(admin.ModelAdmin):
    list_display = ('sigla', 'nome', 'codigo', 'umae')
    list_display_links = ('sigla', 'nome')
    search_fields = ('sigla', 'nome')
    list_per_page = 20


@admin.register(Cargo)
class CargoAdmin(admin.ModelAdmin):
    list_display = ('nome', 'nivel', 'grupo')
    search_fields = ('nome',)
    list_per_page = 20

    list_filter = ('nivel', 'grupo')


@admin.register(Servidor)
class ServidorAdmin(admin.ModelAdmin):
    list_display = ("siape", "nome", "cpf_display", "cargo", "lotacao")
    search_fields = ("siape", "nome", "cpf", "cargo__nome", "lotacao__unidade__nome", "lotacao__unidade__sigla")
    list_display_links = ("siape", "nome", "cpf_display")
    list_per_page = 20

    list_filter = ("local", "cargo__grupo")


@admin.register(Lotacao)
class LotacaoAdmin(admin.ModelAdmin):
    list_display = ("unidade", "servidor", "dt_entrada")
    search_fields = ("unidade__nome", "unidade__sigla", "servidor__nome")
    list_per_page = 20

    list_filter = ("unidade", "dt_entrada")


@admin.register(Funcao)
class FuncaoAdmin(admin.ModelAdmin):
    list_display = ("servidor", "codigo", "descricao", "unidade", "dt_entrada")
    search_fields = ("unidade__nome", "unidade__sigla", "servidor__nome")
    list_per_page = 20

    list_filter = ("codigo", "dt_entrada")






