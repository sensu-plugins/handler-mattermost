#!/opt/sensu/embedded/bin/ruby
require 'sensu-handler'
require 'json'
require 'uri'
require 'net/http'
require 'net/https'


# Define class, get settings from config files and conf.d to set required variables for posting to Mattermost
class Show < Sensu::Handler
  def handle

    uri = URI.parse(settings["mattermost"]["url"])
    username = settings["mattermost"]["username"]
    icon_url = settings["mattermost"]["icon_url"]


# Case statement to detect Exit status code of alert
# Exit status code indicates state

#    0 indicates “OK”
#    1 indicates “WARNING”
#    2 indicates “CRITICAL”
#    exit status codes other than 0, 1, or 2 indicate an “UNKNOWN” or custom status

case @event["check"]["status"]
when 0
  exitcode = "OK"
  exiticon = ":white_check_mark:"
when 1
  exitcode = "WARNING"
  exiticon = ":warning:"
when 2
  exitcode = "CRITICAL"
  exiticon = ":sos:"
else
  exitcode = "UNKNOWN"
  exiticon = ":grey_question:"
end

# Format Message displayed in mattermost and body of JSON sent to Mattermost.
body = {text: "
  | Component     | #{@event["client"]["name"]}  |
  |--------------:|:-----------------------------|
  | Check         | #{@event["check"]["name"]}   |
  | Output        | #{@event["check"]["output"]} |
  | Occurrences   | #{@event["occurrences"]}     |
  | Status        | #{exiticon} #{exitcode}      |


", username:username , icon_url:icon_url}

# HTTP POST Message to Mattermost.
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
