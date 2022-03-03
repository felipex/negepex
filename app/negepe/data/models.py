from django.db import models

class Grafico(models.Model):
    titulo = models.CharField(max_length=255)
    especificacao = models.TextField()
    ativo = models.BooleanField(default=True)

    class Meta:
        ordering = ["titulo"]

    def __str__(self):
        return self.titulo

