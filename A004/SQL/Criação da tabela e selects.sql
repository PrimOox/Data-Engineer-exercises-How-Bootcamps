-- Download CSV kaggle: https://www.kaggle.com/dhruvildave/billboard-the-hot-100-songs

CREATE TABLE PUBLIC."Billboard1" (
	"date" DATE NULL
	,"rank" int4 NULL
	,song VARCHAR(300) NULL
	,artist VARCHAR(300) NULL
	,"last-week" float8 NULL
	,"peak-rank" int4 NULL
	,"weeks-on-board" int4 NULL
	);

SELECT "date"
	,"rank"
	,song
	,artist
	,"last-week"
	,"peak-rank"
	,"weeks-on-board"
FROM PUBLIC."Billboard";


select 
    TBB."date", 
    TBB."rank", 
    TBB.song, 
    TBB.artist, 
    TBB."last-week", 
    TBB."peak-rank", 
    TBB."weeks-on-board" 
from 
    public."Billboard" as TBB 
limit 10;

select max(TBB."date") as max_date from "Billboard" as TBB limit 10;
select TBB."date" as max_date from "Billboard" as TBB order by "date" desc limit 1 ;

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
where TBB."date" = '2021-11-06' and TBB."rank" <= 10;


