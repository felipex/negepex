# Generated by Django 4.0.1 on 2022-06-10 10:52

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0008_alter_lotacao_dt_entrada'),
    ]

    operations = [
        migrations.AlterField(
            model_name='lotacao',
            name='dt_entrada',
            field=models.DateField(default=datetime.date(2022, 6, 10), verbose_name='data de entrada'),
        ),
    ]
