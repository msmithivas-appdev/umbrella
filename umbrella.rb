p "Where are you located?"

user_location = gets.chomp
# user_location = "Chicago"
# p user_location

require "open-uri"
require "json"

gmaps_api_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=AIzaSyB92cYxPcYqgjwBJfWlwDQw_7yjuyU3tpA"

raw_response = URI.open(gmaps_api_url).read

# p raw_response
parsed_data = JSON.parse(raw_response)
# p parsed_data.keys
results_array = parsed_data.fetch("results")
first_result = results_array.at(0)
geo = first_result.fetch("geometry")
loc = geo.fetch("location")

# p geo
latitude = loc.fetch("lat")
longitude = loc.fetch("lng")
# p latitude
# p longitude

darksky_url = "https://api.darksky.net/forecast/71174c5d293588d2f0ba4c0c7448bcfb/#{latitude},#{longitude}"
# p darksky_url

darksky_response = URI.open(darksky_url).read
parsed_data2 = JSON.parse(darksky_response)
# p parsed_data2.keys
summary = parsed_data2.fetch("hourly").fetch("summary")
temp = parsed_data2.fetch("currently").fetch("temperature")

p "=" * 30
p "     Will you need an umbrella today?     "
p "=" * 30
p "Checking the weather at #{user_location}...."
p "It is currently #{temp} deg F."
p "Next hour: #{summary}"

# hourly_temp = parsed_data2.fetch("hourly").fetch("data").fetch(0).fetch("precipProbability")
# hourly_time = parsed_data2.fetch("hourly").fetch("data").fetch(0).fetch("time")
# interval_time = Time.at(hourly_time)
# p interval_time


temp_hash = Hash.new

12.times do |x|
temp_hash.store(parsed_data2.fetch("hourly").fetch("data").fetch(x).fetch("time"), parsed_data2.fetch("hourly").fetch("data").fetch(x).fetch("precipProbability"))
end
# p temp_hash

counter = false
temp_hash.each do |time,precip|
if precip > 10.0
  p "The precipitation probability at #{Time.at(time)} is #{precip}"
counter = true
end
end
if counter == true
  p "You might want to carry an umbrella!"
else
  p "You probably won't need an umbrella today."
end
