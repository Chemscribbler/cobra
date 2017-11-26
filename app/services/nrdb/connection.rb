module Nrdb
  class Connection
    def initialize(user = nil, access_token = nil)
      @user = user
      @access_token = access_token || user.try(:nrdb_access_token)
    end

    def player_info
      resp = connection.get('/api/2.0/private/account/info')
      raise 'NRDB API connection failed' unless resp.success?

      JSON.parse(resp.body).with_indifferent_access[:data]
    end

    def cards
      resp = public_connection.get('/api/2.0/public/cards')
      raise 'NRDB API connection failed' unless resp.success?

      JSON.parse(resp.body).with_indifferent_access[:data]
    end

    private

    attr_reader :access_token

    def connection
      @connection ||= Faraday.new(url: "https://netrunnerdb.com") do |conn|
        conn.adapter :net_http
        conn.headers[:Authorization] = "Bearer #{access_token}"
      end
    end

    def public_connection
      @connection ||= Faraday.new(url: "https://netrunnerdb.com") do |conn|
        conn.adapter :net_http
      end
    end
  end
end
