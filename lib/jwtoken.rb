module Jwtoken
  class Middleware
    attr_reader :app

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      body = request.body.read
      if !env["HTTP_AUTHORIZATION"] && body.include?("jwt_token")
        if request.media_type == "application/x-www-form-urlencoded"
          jwt_token = Rack::Utils.parse_nested_query(body)["jwt_token"]
          bearer = URI.decode_www_form_component(jwt_token)
          env["HTTP_AUTHORIZATION"] = bearer
        elsif request.media_type == "application/json"
          bearer = JSON.parse(body)["jwt_token"]
          env["HTTP_AUTHORIZATION"] = bearer
        end
      end
      request.body.rewind
      @app.call(env)
    end
  end
end
