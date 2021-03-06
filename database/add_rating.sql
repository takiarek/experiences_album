CREATE TABLE IF NOT EXISTS users (
  id int PRIMARY KEY,
  name varchar(50),
  email varchar(50) UNIQUE
);
CREATE SEQUENCE IF NOT EXISTS users_id_sequence;
ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_sequence');

CREATE SEQUENCE IF NOT EXISTS movies_id_sequence;
CREATE TABLE IF NOT EXISTS movies (
  id int PRIMARY KEY DEFAULT nextval('movies_id_sequence'),
  title varchar(30) NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS ratings_id_sequence;
CREATE TABLE IF NOT EXISTS ratings (
  id int PRIMARY KEY DEFAULT nextval('ratings_id_sequence'),
  value smallint NOT NULL,
  user_id int NOT NULL REFERENCES users,
  movie_id int NOT NULL REFERENCES movies
);

ALTER TABLE movies ALTER COLUMN title TYPE varchar(100);
