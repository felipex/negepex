from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('dashboard', views.dashboard, name='dashboard'),
    path('servidores', views.servidores, name='servidores'),
    path('servidores_por_carreira', views.servidores_por_carreira, name='servidores_por_carreira'),
    path('servidores_por_unidade', views.servidores_por_unidade, name='servidores_por_unidade'),
    path('servidores_por_unidade_por_sexo', views.servidores_por_unidade_por_sexo, name='servidores_por_unidade_por_sexo'),
]
