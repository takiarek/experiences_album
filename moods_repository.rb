class MoodsRepository
  def all
    connection = PG.connect(dbname: "experiences_album")

    moods = connection.exec("SELECT * FROM moods ORDER BY name ASC") do |result|
      result.map do |mood|
        OpenStruct.new(id: mood["id"], name: mood["name"])
      end
    end
  end

  def ascribe_to_movie(user_id:, movie_id:, moods_ids:)
    connection = PG.connect(dbname: "experiences_album")

    values = moods_ids.map do |mood_id|
      "(#{user_id}, #{movie_id}, #{mood_id})"
    end

    sql_string = "INSERT INTO movies_moods_by_users (user_id, movie_id, mood_id) VALUES " << values.join(", ")

    connection.exec(sql_string)
  end
end
