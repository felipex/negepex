from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.template import loader
from django.shortcuts import render

from core.models import Unidade, Servidor, Lotacao
from django.db import connection
from django.db.models import Prefetch

def index(request):
    return HttpResponse('-- Negepe --')

def tt(request):
    return render(request, 'tt.html')

def dashboard(request):
    return render(request, 'dashboard.html')

def servidor_to_json(s):
    return {            
        'id': s.id,
        'cargo': s.cargo.nome,
        'cargo_grupo': s.cargo.get_grupo_display(),
        'cargo_nivel': s.cargo.get_nivel_display(),
        'local': s.get_local_display(),
        'cor': s.get_cor_display(),
        'sexo': s.get_sexo_display(),
        'ch': s.ch,
        'lotacao': s.lotacao.unidade.sigla,
        'lotacao_nome': s.lotacao.unidade.nome,
        'funcao': s.funcao.codigo if s.funcao else '',
        'funcao_unidade': s.funcao.unidade.nome if s.funcao else '',
        'umae': s.lotacao.unidade.umae,
        'total': 1 
    }

def servidores(request):
    prefetch = Prefetch('lotacao_set')
    ss = Servidor.objects.prefetch_related(prefetch).all()
    data = []
    for s in ss:
        data.append(servidor_to_json(s))
    return JsonResponse(data, safe=False)

'''
def servidor_to_json2(s):
    return {            
        'id': s.id,
        'cargo': s.cargo,
        'cargo_nivel': s.cargo_nivel,
        'cargo_grupo': s.cargo_grupo,
        'local': s.local,
        'cor': s.cor,
        'sexo': s.sexo,
        'ch': s.ch,
        'lotacao': s.lotacao,
        'lotacao_nome': s.lotacao_nome,
        'funcao': s.funcao,
        'funcao_unidade': s.funcao_unidade,
        'total': 1 
    }
'''

def dictfetchall(cursor):
    "Return all rows from a cursor as a dict"
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]

def servidores2(request):
    with connection.cursor() as cursor:
        cursor.execute('''
        select s.id, 
        c.nome as cargo, 
        case 
          when c.grupo = 'D' then 'Docente'
          when c.grupo = 'T' then 'Técnico-Administrativo'
        end as cargo_grupo, 
        case
          when c.nivel = 'X' then 'Docente'
          when c.nivel = 'C' then 'Fundamental'
          when c.nivel = 'D' then 'Médio'
          when c.nivel = 'E' then 'Superior'
        end as cargo_nivel,
        case 
            when s.local = 'J' then 'Juazeiro do Norte' 
            when s.local = 'B' then 'Barbalha' 
            when s.local = 'C' then 'Crato' 
            when s.local = 'S' then 'Brejo Santo' 
        end as local,
        s.cor, 
        case 
          when s.sexo = 'F' then 'Feminino'
          else 'Masculino'
        end as sexo, s.ch,
        u.sigla as lotacao, u.nome as lotacao_nome,
        coalesce(f.codigo, '') as funcao, coalesce(uf.nome, '') as funcao_unidade, 
        u.umae as umae, 1 as total
        from core_servidor s
        left join core_cargo c on s.cargo_id = c.id 
        left join core_funcao f on s.id = f.servidor_id
        left join core_lotacao l on s.id = l.servidor_id
        left join core_unidade u on l.unidade_id = u.id
        left join core_unidade uf on f.unidade_id = uf.id

        where l.dt_entrada = (select max(dt_entrada) from core_lotacao l2 
                              where l2.servidor_id = l.servidor_id)
        and (f.dt_entrada is null 
             or f.dt_entrada = (select max(dt_entrada) from core_funcao f2 
                              where f2.servidor_id = f.servidor_id))
        ;''')

        data = dictfetchall(cursor)
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
