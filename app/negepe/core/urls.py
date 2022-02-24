from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('tt', views.tt, name='tt'),
    path('dashboard', views.dashboard, name='dashboard'),
    path('servidores', views.servidores, name='servidores'),
    path('get_graph_spec', views.get_graph_spec, name='get_graph_spec'),
    path('servidores2', views.servidores2, name='servidores2'),
    path('servidores_por_carreira', views.servidores_por_carreira, name='servidores_por_carreira'),
    path('servidores_por_unidade', views.servidores_por_unidade, name='servidores_por_unidade'),
    path('servidores_por_unidade_por_sexo', views.servidores_por_unidade_por_sexo, name='servidores_por_unidade_por_sexo'),
]
