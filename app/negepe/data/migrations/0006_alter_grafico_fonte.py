# Generated by Django 4.0.1 on 2022-06-10 11:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('data', '0005_alter_grafico_options_alter_grafico_especificacao_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='grafico',
            name='fonte',
            field=models.CharField(blank=True, default='', max_length=500, null=True),
        ),
    ]
