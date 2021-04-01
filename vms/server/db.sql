CREATE DATABASE bf;
CREATE USER bfuser;
GRANT ALL ON DATABASE bf TO bfuser;

USE bf;

CREATE TABLE users (
userid INT NOT NULL DEFAULT unique_rowid(),
name STRING(50) NULL,
picture STRING(300) NULL,
status STRING(10) NULL,
posts INT NULL,
comments INT NULL,
lastpostdate TIMESTAMP NULL DEFAULT now():::TIMESTAMP,
createdate TIMESTAMP NULL DEFAULT now():::TIMESTAMP,
FAMILY "primary" (userid, posts, comments, lastpostdate),
FAMILY "secondary" (name, picture,status, createdate)
);


CREATE TABLE posts (
postid INT NOT NULL DEFAULT unique_rowid(),
userid INT NOT NULL,
text STRING(300) NULL,
name STRING(150) NULL,
postdate TIMESTAMP NULL DEFAULT now():::TIMESTAMP,
INDEX posts_auto_index_posts_users_fk (userid ASC),
FAMILY "primary" (postid, userid, text, name, postdate)
);


CREATE TABLE comments (
commentid INT NOT NULL DEFAULT unique_rowid(),
userid INT NOT NULL,
postid INT NOT NULL,
text STRING(300) NULL,
postdate TIMESTAMP NULL DEFAULT now():::TIMESTAMP,
INDEX comments_userid_idx (userid ASC),
INDEX comments_postid_idx (postid ASC),
FAMILY "primary" (commentid, userid, postid, text, postdate)
);

CREATE table config ( key STRING(100), value STRING(500) );
insert into config ( key, value ) values ( 'migration_key', '$MIGRATION_KEY' );
