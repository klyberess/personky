#!/usr/bin/ruby
require 'net/http'
require 'json'
require 'fileutils'

# Start loop.
until 1 == 2 do
	
	# Grab the weather for Goteborg, Sweden.
	weather_url = 'http://api.wunderground.com/api/a7f118ad23b2d3b9/conditions/q/SE/goteborg.json'
	response = Net::HTTP.get_response(URI.parse(weather_url))
	response_hash = JSON.parse(response.body)
	$currentWeather = response_hash['current_observation']['weather']

	# Remove light, normal and heavy variations of conditions. We don't care.
	$currentWeather.gsub!("Light ", "")
	$currentWeather.gsub!("Heavy ", "")
	
	# Make current condition image correspond to the weather.
	case $currentWeather
		when "Clear", "Partly Cloudy", "Scattered Clouds"
				FileUtils.cp '$HOME/personky/res/clear.png', '$HOME/personky/currentCondition.png'
		when "Mostly Cloudy", "Scattered Clouds", "Funnel Cloud", "Overcast"
				FileUtils.cp '$HOME/personky/res/cloudy.png', '$HOME/personky/currentCondition.png'
		when "Drizzle", "Rain", "Ice Crystals", "Ice Pellets", "Hail", "Spray", "Rain Showers", "Rain Mist", "Freezing Rain", "Freezing Drizzle", "Unknown Precipitation", "Ice Pellet Showers", "Hail Showers", "Small Hail Showers"
				FileUtils.cp '$HOME/personky/res/rain.png', '$HOME/personky/currentCondition.png'
		when "Fog", "Freezing Fog", "Mist", "Haze", "Fog Patches", "Patches of Fog", "Shallow Fog", "Partial Fog" # In what world is there need of a distinction between "fog patches" & "patches of fog"?!
				FileUtils.cp '$HOME/personky/res/fog.png', '$HOME/personky/currentCondition.png'
		when "Thunderstorm", "Thunderstorms and Rain", "Thunderstorms and Snow", "Thunderstorms and Ice Pellets", "Thunderstorms with Hail", "Thudnerstorms with Small Hail"
				FileUtils.cp '$HOME/personky/res/tstorms.png', '$HOME/personky/currentCondition.png'
		when "Snow", "Snow Grains", "Snow Showers", "Snow Blowing Snow Mist", "Blowing Snow"
				FileUtils.cp '$HOME/personky/res/snow.png', '$HOME/personky/currentCondition.png'
		when "*"
				FileUtils.cp '$HOME/personky/res/unknown.png', '$HOME/personky/currentCondition.png'
	end 

	# Make time-of-day image correspond to system time.
	t = Time.now
	if t.hour < 6
		FileUtils.cp '$HOME/personky/res/night.png', '$HOME/personky/timeOfDay.png'
	elsif t.hour < 12
		FileUtils.cp '$HOME/personky/res/morning.png', '$HOME/personky/timeOfDay.png'
	elsif t.hour < 18
		FileUtils.cp '$HOME/personky/res/afternoon.png', '$HOME/personky/timeOfDay.png'
	else
		FileUtils.cp '$HOME/personky/res/evening.png', '$HOME/personky/timeOfDay.png'

	# Pause script for 5 minutes (due to API call limit).
	sleep 300

# End of looped segment.
end
