from django.db import models

class Grafico(models.Model):
    titulo = models.CharField("título", max_length=255)
    fonte = models.CharField(max_length=500, default="", blank=True, null=True)
    especificacao = models.TextField("especificação")
    ativo = models.BooleanField(default=True)

    class Meta:
        ordering = ["titulo"]
        verbose_name = "gráfico"

    def __str__(self):
        return self.titulo

