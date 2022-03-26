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


-- exemplo geral
WITH T(StyleID, ID, Nome) 
     AS (SELECT 1,1, 'Rhuan' UNION ALL 
         SELECT 1,1, 'Andre' UNION ALL 
         SELECT 1,2, 'Ana' UNION ALL 
         SELECT 1,2, 'Maria' UNION ALL 
         SELECT 1,3, 'Letícia' UNION ALL 
         SELECT 1,3, 'Lari' UNION ALL 
         SELECT 1,4, 'Edson' UNION ALL 
         SELECT 1,4, 'Marcos' UNION ALL 
         SELECT 1,5, 'Rhuan' UNION ALL 
         SELECT 1,5, 'Lari' UNION ALL 
         SELECT 1,6, 'Daisy' UNION ALL 
         SELECT 1,6, 'João' 
         ) 
SELECT *, 
       ROW_NUMBER() OVER(PARTITION BY StyleID ORDER BY ID) AS "ROW_NUMBER", 
       RANK() OVER(PARTITION BY StyleID ORDER BY ID) AS "RANK", 
       DENSE_RANK() OVER(PARTITION BY StyleID ORDER BY ID) AS "DENSE_RANK", 
       PERCENT_RANK() OVER(PARTITION BY StyleID ORDER BY ID) AS "PERCENT_RANK", 
       CUME_DIST() OVER(PARTITION BY StyleID ORDER BY ID) AS "CUME_DIST", 
       CUME_DIST() OVER(PARTITION BY StyleID ORDER BY ID DESC) AS "CUME_DIST_DESC", 
       FIRST_VALUE(Nome) OVER(PARTITION by StyleID ORDER BY ID) AS "FIRST_VALUE", 
       LAST_VALUE(Nome) OVER(PARTITION by StyleID ORDER BY ID) AS "LAST_VALUE", 
       NTH_VALUE(Nome,5) OVER(PARTITION by StyleID ORDER BY ID) AS "NTH_VALUE", 
       NTILE (5) OVER (ORDER BY StyleID) AS "NTILE_5", 
       LAG(Nome, 1) over(order by ID) AS "LAG_NOME", 
       LEAD(Nome, 1) over(order by ID) AS "LEAD_NOME"
FROM T;


