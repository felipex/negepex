# Generated by Django 4.0.1 on 2022-06-10 10:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('data', '0002_alter_grafico_options'),
    ]

    operations = [
        migrations.AddField(
            model_name='grafico',
            name='fonte',
            field=models.TextField(default=''),
        ),
    ]
