# Generated by Django 4.0.1 on 2022-02-24 19:12

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Grafico',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('titulo', models.CharField(max_length=255)),
                ('especificacao', models.TextField()),
                ('ativo', models.BooleanField(default=True)),
            ],
        ),
    ]
