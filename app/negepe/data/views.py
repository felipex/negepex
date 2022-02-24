from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.template import loader
from django.shortcuts import render
from data.models import Grafico

def dashboard(request):
    context = {
        'graficos': Grafico.objects.all()
    }
    return render(request, 'data/dashboard.html', context)



