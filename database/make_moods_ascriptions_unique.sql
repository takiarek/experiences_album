ALTER TABLE IF EXISTS moods_ascriptions
  DROP CONSTRAINT IF EXISTS user_id_movie_id_mood_id_key;

ALTER TABLE IF EXISTS moods_ascriptions
  ADD CONSTRAINT user_id_movie_id_mood_id_key UNIQUE (user_id, movie_id, mood_id);
