
SELECT SUBSTRING(doc->"$.dataYmd", 1, 11), count(*) FROM pld_horario.metricas_horarias group by SUBSTRING(doc->"$.dataYmd", 1, 11) having count(*) != 96;

SELECT * FROM nome_collection where doc->"$.id" = "123";

SELECT * FROM negociacoes_analises where doc->"$._id" = "0000610124cc000000000005e125";