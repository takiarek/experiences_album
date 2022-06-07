def assert_equal(result, expected_result)
  if result == expected_result
    puts "Passed!"
  else
    puts "Failed!"
    puts
    puts "Expected result:"
    puts
    puts "#{expected_result.inspect}"
    puts
    puts "Actual result:"
    puts
    puts "#{result.inspect}"
  end
end

def print_test_name(name)
  puts "------------------------------"
  puts name
  puts "------------------------------"
end

def moods_ascribed_count(connection)
  connection.exec("SELECT COUNT(*) FROM moods_ascriptions") do |result|
    result.first["count"].to_i
  end
end
