begin
  require 'rubygems'
  require 'base64'
  require 'openssl'
  require 'uri'
  require 'cgi'
  require 'net/http'
  require 'json'
  end

module Opscode
  module Cloudstack
    ASYNC_POLL_INTERVAL = 5.0
    ASYNC_TIMEOUT = 600
    module Admin
      def send_request(admin_api_url, params)
        params['response'] = 'json'
        params_arr = []
        params.sort.each { |elem|
          params_arr << elem[0].to_s + '=' + elem[1].to_s
        }
        data = params_arr.join('&')
        encoded_data = URI.encode(data.downcase).gsub('+', '%20').gsub(',', '%2c')
        url = "#{admin_api_url}?#{data}"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        if !response.is_a?(Net::HTTPOK) then
          puts "Error #{response.code}: #{response.message}"
          puts JSON.pretty_generate(JSON.parse(response.body))
          puts "URL: #{url}"
          exit 1
        end
        json = JSON.parse(response.body)
        json[params['command'].downcase + 'response']
      end
    def send_async_request(params)
          json = send_request(params)

          params = {
              'command' => 'queryAsyncJobResult',
              'jobId' => json['jobid']
          }
          max_tries = (ASYNC_TIMEOUT / ASYNC_POLL_INTERVAL).round
          max_tries.times do
            json = send_request(params)
            status = json['jobstatus']
            print "."
            if status == 1 then
              return json['jobresult']
            elsif status == 2 then
              print "\n"
              puts "Request failed (#{json['jobresultcode']}): #{json['jobresult']}"
              exit 1
            end
            STDOUT.flush
            sleep ASYNC_POLL_INTERVAL
          end
          print "\n"
          puts "Error: Asynchronous request timed out"
          exit 1
        end
      end
    end
  end
