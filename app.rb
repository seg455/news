require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "de749dae761f2a80ff375941c952c769"

url = "http://newsapi.org/v2/top-headlines?country=us&apiKey=7c31cbda4da041db9af669c5e235a71d"
news = HTTParty.get(url).parsed_response.to_hash
# news is now a Hash you can pretty print (pp) and parse for your output

get "/" do
  view "ask"
end

get "/news" do
    results = Geocoder.search(params["location"])
    lat_long = results.first.coordinates # => [lat, long]
    results = Geocoder.search(params["location"])
    lat_long = results.first.coordinates # => [lat, long]
    lat = lat_long[0]
    long = lat_long[1]
    forecast = ForecastIO.forecast(lat,long).to_hash
    @current_temperature = forecast["currently"]["temperature"]
    @current_conditions = forecast["currently"]["summary"]
    @location = params["location"]
    @forecast_array = forecast["daily"]["data"]
    @tomorrow_temperature = forecast["daily"]["data"][1]["temperatureHigh"]
    @tomorrow_conditions = forecast["daily"]["data"][1]["summary"]
    @forecast = forecast
    @news = news
    @headline1 = news["articles"][0]["title"]
    @link1 = news["articles"][0]["url"]
    @headline2 = news["articles"][1]["title"]
    @link2 = news["articles"][1]["url"]

    view "news"

end