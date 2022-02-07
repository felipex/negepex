from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.template import loader
from django.shortcuts import render

from core.models import Unidade, Servidor


def index(request):
    return HttpResponse('-- Negepe --')

def dashboard(request):
    return render(request, 'tt.html')

def servidor_to_json(s):
    return {            
        'siape': s.siape,
        'id': s.id,
        'cargo': s.cargo.nome,
        'cargo_nivel': s.cargo.get_nivel_display(),
        'cargo_grupo': s.cargo.get_grupo_display(),
        'local': s.get_local_display(),
        'cor': s.get_cor_display(),
        'sexo': s.get_sexo_display(),
        'ch': s.ch,
        'lotacao': s.lotacao.unidade.nome,
        'funcao': s.funcao.codigo if s.funcao else '',
        'funcao_unidade': s.funcao.unidade.nome if s.funcao else ''
    }


def servidores(request):
    ss = Servidor.objects.all()
    data = []
    for s in ss:
        data.append(servidor_to_json(s))
    return JsonResponse(data, safe=False)


def servidores_por_unidade(request):
    unidades = Unidade.objects.raw('select u.id, u.nome, count(*) as total from core_servidor s, core_lotacao l, core_unidade u where s.id = l.servidor_id and u.id = l.unidade_id  group by u.id, u.nome;')
    data = []
    for u in unidades:
        data.append({
            'unidade': u.nome,
            'total': u.total
        })
    return JsonResponse(data, safe=False)


def servidores_por_unidade_por_sexo(request):
    unidades = Unidade.objects.raw('select u.id, u.nome, s.sexo, count(*) as total from core_servidor s, core_lotacao l, core_unidade u where s.id = l.servidor_id and u.id = l.unidade_id  group by u.id, u.nome, s.sexo order by u.id, u.nome, s.sexo;')
    data = []
    for u in unidades:
        data.append({
            'unidade': u.nome,
            'sexo': 'Feminino' if u.sexo == 'F' else 'Masculino',
            'total': u.total
        })
    return JsonResponse(data, safe=False)


def servidores_por_carreira(request):
    unidades = Unidade.objects.raw('select u.id, c.grupo, count(*) as total from core_servidor s, core_lotacao l, core_unidade u, core_cargo c where s.id = l.servidor_id and u.id = l.unidade_id and s.cargo_id = c.id group by u.id, c.grupo order by u.id, c.grupo;')
    data = []
    for u in unidades:
        data.append({
            'grupo': 'TAE' if u.grupo == 'T' else 'Docente',
            'total': u.total
        })
    return JsonResponse(data, safe=False)
