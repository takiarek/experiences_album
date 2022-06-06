ALTER SEQUENCE IF EXISTS movies_moods_by_users_id_sequence
  RENAME TO moods_ascriptions_id_sequence;

ALTER TABLE IF EXISTS movies_moods_by_users
  RENAME TO moods_ascriptions;

ALTER TABLE IF EXISTS moods_ascriptions
  ALTER COLUMN id SET DEFAULT nextval('moods_ascriptions_id_sequence');
