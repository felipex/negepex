include .env
export 
VOLUME = $(APP)_db_volume
NETWORK = $(APP)_network
DBHOST = $(APP)_data

testa:
	@echo "O nome do volume é $(VOLUME)."

build_nginx:
	@echo "Build docker file to NGINX."
	docker build -f ./nginx/Dockerfile -t nginx .

nginx_:
	docker run -d --rm -p 80:80 \
		--expose 80 \
		--mount type=bind,source=$(PWD)/app,target=/home/appuser/webapp \
		--mount type=bind,source=$(PWD)/nginx/conf.d,target=/etc/nginx/conf.d \
		--network $(NETWORK) \
		--name nginx \
		nginx


build_prod:
	@echo "Build docker file to PRODUCTION based in Dockerfile.prod."
	docker build -f Dockerfile.prod -t $(APP) .

build_dev: 
	@echo "Build docker file to DEVELOPMENT based in Dockerfile.dev."
	docker build -f Dockerfile.dev -t $(APP) .

create_network:
	@echo "Create the user-defined network $(NETWORK)."
	docker network create --driver bridge $(NETWORK)

create_db_volume:
	@echo "Create the volume $(VOLUME) to database."
	docker volume create $(VOLUME)

run_:
	docker run --rm -p $(PORT):$(PORT) \
		--expose $(PORT) \
		--env-file .env \
		--mount type=bind,source=$(PWD)/app,target=/home/appuser/webapp \
		--network $(NETWORK) \
		--name $(APP) \
		$(APP) \
		bash
	    #django-admin startproject negepe	

run:
	docker run -d --rm -p $(PORT):$(PORT) \
		--expose $(PORT) \
		--env-file .env \
		--mount type=bind,source=$(PWD)/app,target=/home/appuser/webapp \
		--network $(NETWORK) \
		--name $(APP) \
		$(APP)

pg_down:
	#ps -A | grep postgres | sudo kill $(awk '{print $1}')
	for p in "$(ps -u postgres -o pid)" do print "$p" 

db_up:
	docker run -d --rm\
		--publish 5432:5432\
		--mount type=volume,source=$(VOLUME),target="/var/lib/postgresql/data"\
		--env POSTGRES_PASSWORD=$(POSTGRES_PASSWORD)\
		--env POSTGRES_DB=$(POSTGRES_DB)\
		--name $(DBHOST) \
		--hostname postgres\
		--network $(NETWORK) \
		postgres:14

start: db_up run

pgadmin:
	docker run -d --rm\
		--publish 9000:80\
		--mount type=volume,source=pgadmin,target=/var/lib/pgadmin\
		--env PGADMIN_DEFAULT_EMAIL=$(PGADMIN_DEFAULT_EMAIL)\
		--env PGADMIN_DEFAULT_PASSWORD=$(PGADMIN_DEFAULT_PASSWORD)\
		--name pgadmin\
		--network $(NETWORK) \
		dpage/pgadmin4

down_app:
	docker rm -f negepe negepe_data

login:
	heroku container:login

push:
	heroku container:push web -a $(APP)

release: push
	heroku container:release web -a $(APP)


gitlog:
	git log --oneline --decorate --all --graph


conecta_db:
	docker exec -it negepe_data psql -U postgres -d negepe

importcsvcap:
	@echo "Copiando arquivo para o container..."
	docker cp tools/CAP_Controle_de_Pessoal.csv negepe_data:/home/CAP_Controle_de_Pessoal.csv
	@echo "Importando arquivo..."
	docker exec -i negepe_data psql -U postgres -d negepe -c "set datestyle to german; copy cap_planilha(nome, sexo, siape, racacor, cpf, dt_nasc, email, cargo, nivel, campus, unidade, funcao, cod_funcao, ch, dt_exercicio) from '/home/CAP_Controle_de_Pessoal.csv' delimiter ',' csv header"
	
restore:
	cat bknegepe.sql | docker exec -i negepe_data psql -U postgres -d  $(database)
	
backup:
	docker exec -t negepe_data pg_dump -c -U postgres -d $(database) > bknegepe.sql
	# Não funciona mais. Ver qual o problema.
	#docker exec -t negepe_data pg_dump -c -U postgres -d $(database) > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

sqlexec:
	@echo "Copiando o arquivo."
	docker cp ./sql/vw.sql negepe_data:/tmp
	@echo "Executando o arquivo."
	docker exec -it negepe_data psql -U postgres -d negepe -f "./tmp/vw.sql" 

sqlteste:
	docker exec -it negepe_data psql -U postgres -d teste -c "select * from campus;"
