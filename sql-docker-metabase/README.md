## Tópicos abordados:
- [Criando um banco de dados com docker](#criando-um-banco-de-dados-com-docker)
- [Criação de tabelas + Select + Where + Group by](#criação-de-tabelas--select--where--group-by)
- [CTEs e Window functions](#ctes-e-window-functions)
- [Criando, atualizando e deletando tabelas e views para deduplicar dados](#criando-atualizando-e-deletando-tabelas-e-views-para-deduplicar-dados)
- [Acessando um banco de dados com Python](#acessando-um-banco-de-dados-com-python)
- [Conectando a uma ferramenta de BI (Metabase)](#conectando-a-uma-ferramenta-de-bi-metabase)

## Criando um banco de dados com Docker

1. Criamos um arquivo `index.html` em uma pasta com o nome de web
2. Na raiz de nossa aula criamos um arquivo chamado `Dockerfile` esse arquivo é a estrutura base de uma imagem
3. No arquivo colocamos o seguinte código:
```Dockerfile
#FROM: QUAL IMAGEM E QUAL VERSÃO?  
FROM httpd 
#COPIA ARQUIVOS DA MAQUINA PARA O CONTAINER NO BUILD 
COPY ./web/ /usr/local/apache2/htdocs/ 
EXPOSE 80
```
Pronto! Nosso servidor está preparado. Para subir ele primeiro precisamos montar a imagem _build_ e depois subir o container _run_
```bash
docker build -t web_apache .
```
Onde:  
`-t` é para nomear nossa imagem, caso contrário o docker dará um nome qualquer  
`web_apache` é o nome que escolhemos  
`.` é o local onde esta nosso Dockerfile  
```bash
docker run -d -p 80:80 web_apache     
```
Onde:  
`-d` é o detach ou seja, executa sem travar o terminal  
`-p 80:80` é o mapeamento de portas, aqui ele esta encaminhando a porta 80 do container na porta 80 da nossa maquina, não necessáriamente precisa ser o mesmo numero podemos usar um 80:4242  
`web_apache` é o nome da nossa imagem  

### Alguns comandos importantes:

- `docker ps` : mostra os containers que temos ativos
- `docker image ls` : lista as imagens que temos na maquina
- `docker image rm <<nome>>` : remove a imagem da maquina
- `docker stop **id**` : para a imagem com o id selecionado
  
Outras imagens pode ser obtidas pelo [Docker Hub](https://hub.docker.com)

## PostgreSQL e o Docker Compose
Agora podemos montar um servidor postgre simples para um banco de dados, para saber qual imagem usar podemos consultar o [Docker Hub](https://hub.docker.com).  
Para subir uma imagem postgre precisamos de um pouco mais que um Dockerfile, sendo assim vamos usar um arquivo _.yml_ e montar um aquivos para o _docker-compose_.  
A diferença entre o Dockerfile e Docker compose é que no Dockerfile você cria uma imagem que os containers irão usar como base para serem iniciados. No Docker compose você irá criar uma stack de containers a partir de uma imagem base.  
O arquivo docker-compose.yml ficará assim:
```yml
version: "3"
services:
    db:
        image: postgres 
        container_name: "pg_container"
        restart: always 
        environment: 
            - POSTGRES_USER=root 
            - POSTGRES_PASSWORD=root 
            - POSTGRES_DB=test_db 
        ports: 
            - "5432:5432"
        volumes: 
            - "./db:/var/lib/postgresql/data/"
```
## Comandos Docker Compose
- Subir um docker travando o terminal:
```bash
docker-compose up db
```
- Para finalizar o docker, basta fechar o app no terminal com o comando `CTRL+C`
- Para derrubar a rede do container:
```bash
docker-compose down
```
- Para subir o docker sem travar o terminal adicionamos a tag `-d`:
```bash
docker-compose up -d db
```
- Para listar os composes abertos usamos:
```bash
docker-compose ps
```

## Criação de tabelas + Select + Where + Group by

Para uma tabela de testes, vamos usar os dados obtidos no kaggle no [link](https://www.kaggle.com/dhruvildave/billboard-the-hot-100-songs);  
Primeiro criamos uma tabela com os campos necessários:  
```SQL
CREATE TABLE public."Billboard1" ( 
    "date" date NULL, 
    "rank" int4 NULL, 
    song varchar(300) NULL, 
    artist varchar(300) NULL, 
    "last-week" float8 NULL, 
    "peak-rank" int4 NULL, 
    "weeks-on-board" int4 NULL 
);
```
Então carregamos o CSV pelo DBeaver  

Vamos dar uma olhada em nossa base  
```SQL
select
"date",
"rank",
song,
artist,
"last-week",
"peak-rank",
"weeks-on-board"
from
"Billboard";
```
Alguns pontos:
- Em alguns campos estamos usando " para listar e outros não, isso se da quando temos caracteres especiais como o " " (espaço) no nome do campo ou quando o campo possui o nome de um comando sql como date ou rank.
- Nosso select esta abrindo uma consulta em toda a base, mas so queremos dar uma olhada nela, uma pratica muito importante para isso é utilizar o argumento `LIMIT` que faz uam extração menor da base de forma mais rápida e com menor impacto no banco.
- Outra boa pratica que não estamos aplicando no código acima é a de nomear a tabela e adicionar os prefixos dos campos, isso da mais organização a nosso código, antecipa o calculo do banco e evita problemas quando formos usar joins.  
Atentando a esses pontos nosso código fica assim:
```SQL
select 
    TBB."date", 
    TBB."rank", 
    TBB.song, 
    TBB.artist, 
    TBB."last-week", 
    TBB."peak-rank", 
    TBB."weeks-on-board" 
from 
    "Billboard" as TBB 
limit 10;
```
Vamos extrair alguns dados:
- Qual a data mais recente que temos informação?  

Maneira 1:
```SQL
select max(TBB."date") as max_date from "Billboard" as TBB limit 10;
```
Ou
```SQL
select max(TBB."date") as max_date from "Billboard" as TBB;
```
Maneira 2:
```SQL
select TBB."date" as max_date from "Billboard" as TBB order by "date" desc 
limit 1 ;
```
No primeiro modo o `limit 10`  não interfere no resultado, e aqui utilizamos a função de Maximo, que retorna o maior valor da série.  
Ja no segundo modo reordenamos a base em ordem decrescente e pegamos apenas a primeira linha.  
Outro ponto importante é que eu estou selecionando apenas 1 campo da base, isso é essencial para nossas análises pois assim garantimos que as operações só envolvam os campos necessários, evitando trabalho extra para o BD.  
Com isso podemos saber qual é o TOP 10 da semana mais recente de nossa base. Para fazer esse filtro utilizamos a cláusula `WHERE`
```SQL
select 
    TBB."date", 
    TBB."rank", 
    TBB.song, 
    TBB.artist, 
    TBB."last-week", 
    TBB."peak-rank", 
    TBB."weeks-on-board"
from 
    "Billboard" as TBB 
where TBB."date" = '2021-03-13';
```
Mas como so queremos o TOP10 precisamos adicionar uma nova condição:
```SQL
select 
    TBB."date", 
    TBB."rank", 
    TBB.song, 
    TBB.artist, 
    TBB."last-week", 
    TBB."peak-rank", 
    TBB."weeks-on-board"
from 
    "Billboard" as TBB 
where TBB."date" = '2021-03-13' and TBB."rank" <= 10;
```

## CTEs e Window functions

### CTEs

__Common Table Expressions OU Expressões de Tabela Comuns__  
> "Uma CTE tem o uso bem similar ao de uma subquery ou tabela derivada, com a vantagem do conjunto de dados poder ser utilizado mais de uma vez na consulta, ganhando performance (nessa situação) e também, melhorando a legibilidade do código. Por estes motivos, o uso da CTE tem sido bastante difundido como substituição à outras soluções citadas." [Dirceu Resende](https://www.dirceuresende.com/blog/sql-server-como-criar-consultas-recursivas-com-a-cte-common-table-expressions/)

Sintaxe:  
```SQL
WITH expression_name [ ( column_name [,...n] ) ] 
 
AS 
 
( CTE_query_definition )
```

### Window Function

__Para que serve?__
Poupar esforços em ações de ranqueamento e classificação dentro do banco de dados. Para isso, o Postgre cria uma partição dos dados (window).  
Elas complementam as funções de `SUM`, `COUNT`, `AVG`, `MAX` e `MIN`.  
Podem ser:  
- numeração de registros: `ROW_NUMBER()`
- ranqueamento: `RANK()`, `DENSE_RANK()`, `PERCENT_RANK()`
- subdivisão: `NTILE()`, `LAG()`, `LEAD()`
- recuperação de registros: `FIRST_VALUE()`, `LAST_VALUE()`, `NTH_VALUE()`
- distancia relativa: `CUME_DIST()`
```SQL
WITH CTE_BILLBOARD
AS (
	SELECT DISTINCT t1.artist
		,t1.song
	FROM PUBLIC."Billboard" AS t1
	ORDER BY t1.artist
		,t1.song
	)
SELECT *
		,row_number() OVER (ORDER BY artist, song) AS "row_number" -- numero da linha
		,row_number() OVER (PARTITION BY artist ORDER BY artist, song) AS "row_number_by_artist" -- numero da linha após mudar o artista
		,rank() OVER (PARTITION BY artist ORDER BY artist, song) AS "rank_artist" -- mesma coisa da função de cima
		,lag(song, 1) OVER (ORDER BY artist, song) AS "lag_song" -- busca linha anterior
		,lead(song, 1) OVER (ORDER BY artist, song) AS "lead_song" -- busca próxima linha 
		,first_value(song) OVER (PARTITION BY artist ORDER BY artist, song) AS "first_song" -- busca primeira musica da partição
		,last_value(song) OVER (PARTITION BY artist ORDER BY artist, song RANGE BETWEEN UNBOUNDED PRECEDING
				AND UNBOUNDED FOLLOWING) AS "last_song" -- busca ultima musica da partição
		,nth_value(song, 2) OVER (PARTITION BY artist ORDER BY artist, song) AS "nth_song" -- busca musica na posição x da partição
FROM CTE_BILLBOARD;
```

## Criando, atualizando e deletando tabelas e views para deduplicar dados

```SQL
with cte_dedup as( 
SELECT t1."date" 
    ,t1."rank" 
    ,t1.song  
    ,t1.artist 
    ,row_number() over(partition by t1.artist, t1.song order by 
t1.artist,t1.song, t1."date") as dedup_song 
    ,row_number() over(partition by t1.artist order by t1.artist, 
t1."date") as dedup_artist 
FROM PUBLIC."Billboard" AS t1 order by t1.artist , t1."date" 
) 
select t1."date" 
    ,t1."rank" 
    ,t1.artist 
    ,t1.song  
from cte_dedup as t1 
where  t1.artist  like '%'
and t1.dedup_song = 1
--and t1.dedup_artist = 1 
; 

create table tb_artist as 
select t1."date"
	,t1."rank"
	,t1.artist
	,t1.song
from public."Billboard" as t1
where t1.artist = 'AC/DC'
order by t1.artist, t1.song, t1."date";

insert into tb_artist (
select t1."date"
	,t1."rank"
	,t1.artist
	,t1.song
from public."Billboard" as t1
where t1.artist like 'Elvis%'
order by t1.artist, t1.song, t1."date"
);

create table tb_first_song as( 
with cte_dedup as( 
SELECT t1."date" 
    ,t1."rank" 
    ,t1.song  
    ,t1.artist 
    ,row_number() over(partition by t1.artist, t1.song order by 
t1.artist,t1.song, t1."date") as dedup_song 
    ,row_number() over(partition by t1.artist order by t1.artist, 
t1."date") as dedup_artist 
FROM PUBLIC."Billboard" AS t1 order by t1.artist , t1."date" 
) 
select t1."date" 
    ,t1."rank" 
    ,t1.artist 
    ,t1.song  
from cte_dedup as t1 
where  t1.artist  like '%AC/DC'
or t1.artist  like '%Elvis%'
and t1.dedup_song = 1
--and t1.dedup_artist = 1 
) 
; 
 
drop table tb_first_song; 
 
select * from tb_first_song; 
 
 
create view vw_artist as( 
with cte_dedup_artist as( 
SELECT t1."date" 
    ,t1."rank" 
    ,t1.song  
    ,t1.artist 
    ,row_number() over(partition by artist order by 
t1.artist,t1.song, t1."date") as dedup_song 
    ,row_number() over(partition by t1.artist order by artist, "date") as dedup 
FROM tb_artist as t1
order by t1.artist, t1."date" 
)
select t1."date" 
    ,t1."rank" 
    ,t1.artist 
from cte_dedup_artist as t1
where t1.dedup = 1 
); 
-- drop view vw_artist;
select * from vw_artist;

create view vw_song as( 
select * from tb_first_song 
); 
 
insert into tb_first_song ( 
with cte_dedup as( 
SELECT t1."date" 
    ,t1."rank" 
    ,t1.song  
    ,t1.artist 
    ,row_number() over(partition by t1.artist, t1.song order by 
t1.artist,t1.song, t1."date") as dedup_song 
    ,row_number() over(partition by t1.artist order by t1.artist, 
t1."date") as dedup_artist 
FROM PUBLIC."Billboard" AS t1 order by t1.artist , t1."date" 
) 
select t1."date" 
    ,t1."rank" 
    ,t1.artist 
    ,t1.song  
from cte_dedup as t1 
where  t1.artist  like '%Elvis%'
and t1.dedup_song = 1
--and t1.dedup_artist = 1 
) 
 
select * from vw_song; 
select * from vw_artist; 
 
 
create or replace view vw_song as( 
select * from tb_first_song as t1 where  t1.artist  like '%AC/DC' 
);
```

## Acessando um banco de dados com Python

O arquivo `main.py` exemplifica como fazer a conexão com a base de dados pelo Python, para isso é necessário utilizar os pacotes `sqlalchemy` e `psycopg2`. Dessa forma é possível realizar consultas e carregar dados do banco para o python e transforma-los em Dataframes para poder trabalhar melhor com as análises.

```python
from sqlalchemy import create_engine
import pandas as pd

engine = create_engine(
    'postgresql+psycopg2://root:root@localhost/test_db')

sql = '''
select * from vw_artist;
'''

df_artist = pd.read_sql_query(sql, engine)

df_song = pd.read_sql_query('select * from vw_song;', engine)


sql = '''
insert into tb_artist (
SELECT t1."date"
	,t1."rank"
	,t1.artist
	,t1.song 
FROM PUBLIC."Billboard" AS t1 
where t1.artist like 'Nirvana'
order by t1.artist, t1.song , t1."date" 
);

'''

engine.execute(sql)

```

## Conectando a uma ferramenta de BI (Metabase)

Como já temos o Docker Compose rodando o postgre, apenas adicionamos uma nova imagem chamada de `bi` e linkamos com o banco de dados:

```yml
version: "3"
services:
    db:
        image: postgres 
        container_name: "pg_container"
        restart: always 
        environment: 
            - POSTGRES_USER=root 
            - POSTGRES_PASSWORD=root 
            - POSTGRES_DB=test_db 
        ports: 
            - "5432:5432"
        volumes: 
            - "./db:/var/lib/postgresql/data/"

    bi:
        image: metabase/metabase
        ports:
            - "3000:3000"
        links:
            - db
```