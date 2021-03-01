**Cockroach DB Docker Setup**



*Create Network*

```bash
docker network create -d bridge roachnet
```

*Create volume for each container*

```bash
docker volume create roach1
docker volume create roach2
docker volume create roach3
```

*Start first node*

```bash
docker run -d \
--name=roach1 \
--hostname=roach1 \
--net=roachnet \
-p 26257:26257 -p 8080:8080  \
-v "roach1:/cockroach/cockroach-data"  \
cockroachdb/cockroach:v20.2.4 start \
--insecure \
--join=roach1,roach2,roach3
```

*Start node 2 and 3*

```bash
docker run -d \
--name=roach2 \
--hostname=roach2 \
--net=roachnet \
-v "roach2:/cockroach/cockroach-data" \
cockroachdb/cockroach:v20.2.4 start \
--insecure \
--join=roach1,roach2,roach3
```

```bash
docker run -d \
--name=roach3 \
--hostname=roach3 \
--net=roachnet \
-v "roach3:/cockroach/cockroach-data" \
cockroachdb/cockroach:v20.2.4 start \
--insecure \
--join=roach1,roach2,roach3
```

*Initialize cluster*

```bash
docker exec -it roach1 ./cockroach init --insecure
```

*Enter SQL client*

```bash
docker exec -it roach1 ./cockroach sql --insecure
```

```bash
# Kommandolije i databasen:
cockroach sql \
--insecure \
--user=root \
--host=localhost \
--database=bf
```



*Create database with tables*

```sql
CREATE DATABASE bf;
CREATE USER bfuser;
GRANT ALL ON DATABASE bf TO bfuser;
```

```sql
USE bf;
CREATE table users ( userID INT PRIMARY KEY DEFAULT unique_rowid(), name STRING(50), picture STRING(300), status STRING(10), posts INT, comments INT, lastPostDate TIMESTAMP DEFAULT NOW(), createDate TIMESTAMP DEFAULT NOW());

CREATE table posts ( postID INT PRIMARY KEY DEFAULT unique_rowid(), userID INT, text STRING(300), name STRING(150), postDate TIMESTAMP DEFAULT NOW());

CREATE table comments ( commentID INT PRIMARY KEY DEFAULT unique_rowid(), postID INT, userID INT, text STRING(300),  postDate TIMESTAMP DEFAULT NOW());

CREATE table pictures ( pictureID STRING(300), picture BYTES );

```















