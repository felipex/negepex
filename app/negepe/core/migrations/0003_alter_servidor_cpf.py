# Generated by Django 4.0.1 on 2022-02-01 23:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0002_alter_cargo_codigo_alter_cargo_nivel_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='servidor',
            name='cpf',
            field=models.CharField(max_length=11, verbose_name='CPF'),
        ),
    ]
