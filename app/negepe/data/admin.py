from django.contrib import admin
from .models import Grafico

@admin.register(Grafico) 
class GraficoAdmin(admin.ModelAdmin):
    list_display = ('titulo', 'ativo',)     


