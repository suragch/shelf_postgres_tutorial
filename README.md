# Shelf Postgres tutorial

This is the source code for the [PostgreSQL and Shelf server tutorial on Medium](https://suragch.medium.com/using-postgresql-on-a-dart-server-ad0e40b11947?sk=82a05bd43621e8b2484afc63816036c0). The article describes the setup directions, but in summary, you need to have the following installed:

- PostgreSQL server installed and running on port 5432.
- Dart and Flutter installed.
- The Shelf server running on port 8080.

You also need to initialize a database and table. Here is a summary from the article:

```
createdb mydb
psql mydb
CREATE USER app_user;
ALTER USER app_user WITH PASSWORD 'password123';
CREATE TABLE scores (
  id TEXT PRIMARY KEY,
  created TIMESTAMP WITH TIME ZONE NOT NULL,
  updated TIMESTAMP WITH TIME ZONE NOT NULL,
  user_id TEXT NOT NULL,
  score INTEGER NOT NULL
);
GRANT ALL PRIVILEGES ON TABLE scores TO app_user;
```