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
minutely_hash = parsed_response_2.fetch("minutely")
next_hour = minutely_hash.fetch("summary")

#Forecast
hourly_hash = parsed_response_2.fetch("hourly")
data = hourly_hash.fetch("data")
precip = false
puts "The current temperature: #{current_temp}"
puts next_hour
data[1..12].each do |hour|
  probs = hour.fetch("precipProbability")
  if probs > 0.10
    precip = true
    precip_time = Time.at(hour.fetch("time"))
    seconds_from_now = precip_time - Time.now
    hours_from_now = seconds_from_now / 60 / 60

    puts "In #{hours_from_now.round} hours, there is a #{(probs * 100).round}% chance of precipitation."
  end
end

if precip == true
  puts "You might want to bring an umbrella today!"
else
  puts "You won't need an umbrella today."
end
