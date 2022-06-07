class MoodsAscriptionsRepository
  TABLE = "moods_ascriptions"

  def initialize(connection: PG.connect(dbname: "experiences_album"))
    @connection = connection
  end

  def upsert(user_id:, movie_id:, moods_ids:)
    ascribied_moods_ids = connection.exec("SELECT * FROM #{TABLE} WHERE user_id = #{user_id} AND movie_id = #{movie_id}") do |results|
      results.map { |result| result["mood_id"] }
    end

    moods_to_create = moods_ids - ascribied_moods_ids

    if moods_to_create.any?
      values = moods_to_create.map do |mood_id|
        "(#{user_id}, #{movie_id}, #{mood_id})"
      end

      sql_string = "INSERT INTO #{TABLE} (user_id, movie_id, mood_id) VALUES " << values.join(", ")

      connection.exec(sql_string)
    end

    moods_to_delete = ascribied_moods_ids - moods_ids

    return unless moods_to_delete.any?

    where = moods_to_delete.map { |mood_id| "mood_id = #{mood_id}" }.join(" OR ")
    sql_string = "DELETE FROM #{TABLE} WHERE user_id = #{user_id} AND movie_id = #{movie_id} AND (#{where})"

    connection.exec(sql_string)
  end

  def where(user_id:, movie_id:, only: [])
    columns = only.any? ? only.join(",") : "*"

    connection.exec("SELECT #{columns} from #{TABLE} WHERE user_id = #{user_id} AND movie_id = #{movie_id}") do |results|
      results.map { |result| OpenStruct.new(**result) }
    end
  end

  private
  attr_reader :connection
end
