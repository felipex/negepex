# Generated by Django 4.0.1 on 2022-06-10 11:46

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('data', '0004_alter_grafico_fonte'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='grafico',
            options={'ordering': ['titulo'], 'verbose_name': 'gráfico'},
        ),
        migrations.AlterField(
            model_name='grafico',
            name='especificacao',
            field=models.TextField(verbose_name='especificação'),
        ),
        migrations.AlterField(
            model_name='grafico',
            name='fonte',
            field=models.CharField(blank=True, default='', max_length=500),
        ),
        migrations.AlterField(
            model_name='grafico',
            name='titulo',
            field=models.CharField(max_length=255, verbose_name='título'),
        ),
    ]
