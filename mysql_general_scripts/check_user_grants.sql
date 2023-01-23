set password for teste = password('Dcide123')

-------------------------

SELECT table_schema "DB Name",
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM information_schema.tables 
GROUP BY table_schema; 


SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM information_schema.tables ; 


ALTER USER 'jeffrey'@'localhost' ACCOUNT LOCK;
ALTER USER 'jeffrey'@'localhost' ACCOUNT UNLOCK;

select user,host,account_locked,password_expired from  mysql.user;
select user,host,password_expired from  mysql.user where password_expired='N';

show grants for 'bbce'@'%';

-----------------------

mysql> flush privileges;
mysql> flush hosts;

sudo mysqladmin flush-hosts

-------------------------

mongo -uapicalc -p apicalc

Exportar colection 
mongoexport --db database --host IP ou host --collection collection --out collection.json

Importar collection
mongoimport --db database --host IP ou host --collection collection --file collection.json

Exportar database
mongodump --db <database>  # ir no diretorio dump/ para transferir os arquivos .bson

Import database
mongorestore --db <database> dump/<caminho do dump>  # indicar o diretorio dump/ para buscar arquivos .bson

Criar e dar privilégios a um usuário
mongo> use database_name;
mongo> db.createUser(
   {
     user: "user_name",
     pwd: "password",
     roles: [ { 
        role: "readWrite",  
        db: "database_name" 
      } ]
   }
)

Listar usuarios

mongo> use database_name
mongo> show users;  ou  db.getUsers();

