class MoodsAscriptionsRepository
  TABLE = "moods_ascriptions"

  def initialize(connection: PG.connect(dbname: "experiences_album"))
    @connection = connection
  end

  def create(user_id:, movie_id:, moods_ids:)
    values = moods_ids.map do |mood_id|
      "(#{user_id}, #{movie_id}, #{mood_id})"
    end

    sql_string = "INSERT INTO #{TABLE} (user_id, movie_id, mood_id) VALUES " << values.join(", ")

    connection.exec(sql_string)

    connection.close
  end

  private
  attr_reader :connection
end
