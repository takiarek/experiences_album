CREATE SEQUENCE IF NOT EXISTS moods_id_sequence;
CREATE TABLE IF NOT EXISTS moods (
  id smallint PRIMARY KEY DEFAULT nextval('moods_id_sequence'),
  name varchar(20) UNIQUE NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS movies_moods_by_users_id_sequence;
CREATE TABLE IF NOT EXISTS movies_moods_by_users (
  id int PRIMARY KEY DEFAULT nextval('movies_moods_by_users_id_sequence'),
  user_id int NOT NULL REFERENCES users,
  movie_id int NOT NULL REFERENCES movies,
  mood_id smallint NOT NULL REFERENCES moods
);

INSERT INTO moods (name)
  VALUES
    ('cheerful'),
    ('humorous'),
    ('melancholic'),
    ('nostalgic'),
    ('anxious'),
    ('angry'),
    ('sad'),
    ('romantic'),
    ('hopeful'),
    ('lonely'),
    ('philosophical'),
    ('tense');
