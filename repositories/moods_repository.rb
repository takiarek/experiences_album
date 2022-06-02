class MoodsRepository
  def all
    connection = PG.connect(dbname: "experiences_album")

    moods = connection.exec("SELECT * FROM moods ORDER BY name ASC") do |result|
      result.map do |mood|
        OpenStruct.new(id: mood["id"], name: mood["name"])
      end
    end
  end
end
