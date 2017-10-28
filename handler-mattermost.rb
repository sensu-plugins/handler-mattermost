#!/opt/sensu/embedded/bin/ruby

# Author: uptic B.V.
# Date: 2017-10-28
# Website: https://uptic.nl

require 'sensu-handler'
require 'json'
require 'uri'
require 'net/http'
require 'net/https'

class Show < Sensu::Handler
  def handle

    uri = URI.parse(settings["mattermost"]["url"])
    username = settings["mattermost"]["username"]
    icon_url = settings["mattermost"]["icon_url"]
	
body = {text: "
  | Component     | #{@event["client"]["name"]}  |
  |:--------------|:----------------------------:|
  | Check         | #{@event["check"]["name"]}   |
  | Output        | #{@event["check"]["output"]} |
  | Occurrences   | #{@event["occurrences"]}     |

", username:username , icon_url:icon_url}

https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true

request = Net::HTTP::Post.new(
  uri.request_uri,
  'Content-Type' => 'application/json'
)

request.body = body.to_json

response = https.request(request)

  end
end
