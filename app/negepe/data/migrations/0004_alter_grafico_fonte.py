# Generated by Django 4.0.1 on 2022-06-10 11:00

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('data', '0003_grafico_fonte'),
    ]

    operations = [
        migrations.AlterField(
            model_name='grafico',
            name='fonte',
            field=models.CharField(default='', max_length=500),
        ),
    ]
