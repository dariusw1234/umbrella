require "http"
require "json"
require "dotenv/load"

#Hidden variables...
gmaps_api_key = ENV.fetch("GMAPS_KEY")
pirate_weather_api_key = ENV.fetch("WEATHER_KEY")

#Prompt
puts "Hello! What's your location? (Enter city)"
raw_input = gets.chomp
final_input = raw_input.gsub(" ", "%20")

#Google Maps
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + final_input.downcase + "&key=" + gmaps_api_key

response = HTTP.get(gmaps_url)
parsed_response = JSON.parse(response)

all_results = parsed_response.fetch("results")
first_result = all_results.at(0)
geometry_hash = first_result.fetch("geometry")
location_hash = geometry_hash.fetch("location")

lat = location_hash.fetch("lat")
lng = location_hash.fetch("lng").round(7)

#Pirate Weather
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{lat},#{lng}"

response_2 = HTTP.get(pirate_weather_url)
parsed_response_2 = JSON.parse(response_2)

currently_hash = parsed_response_2.fetch("currently")
current_temp = currently_hash.fetch("temperature")
hourly_hash = parsed_response_2.fetch("hourly")
summary = hourly_hash.fetch("summary")

puts "The current temperature: #{current_temp}. In the next hour: #{summary}"
