require 'rack'
require 'json'

RSpec.describe Jwtoken do
  it "has a version number" do
    expect(Jwtoken::VERSION).not_to be nil
  end

  let(:app) do
    app = Rack::Builder.app do
      use Jwtoken::Middleware
      run lambda { |env| [200, {}, [env['HTTP_AUTHORIZATION']]] }
    end
  end

  it "adds Bearer to Authorization header for application/json requests" do
    body = { jwt_token: "Bearer efgxyz" }.to_json
    env = Rack::MockRequest.env_for("www.name.com")
    env["CONTENT_TYPE"] = "application/json"
    env[Rack::RACK_INPUT] = StringIO.new(body)
    _code, _headers, body = Jwtoken::Middleware.new(app).call(env)
    expect(body).to eq(['Bearer efgxyz'])
  end

  it "adds Bearer to Authorization header for form encoded requests" do
    body = URI.encode_www_form([["jwt_token", "Bearer efgxyz"]])
    env = Rack::MockRequest.env_for("www.name.com")
    env["CONTENT_TYPE"] = "application/x-www-form-urlencoded"
    env[Rack::RACK_INPUT] = StringIO.new(body)
    _code, _headers, body = Jwtoken::Middleware.new(app).call(env)
    expect(body).to eq(['Bearer efgxyz'])
  end

  it "does not but, but does not add Bearer to Authorization header when content_type is not application/x-www-form-urlencoded or application/json" do
    body = URI.encode_www_form([["jwt_token", "Bearer efgxyz"]])
    env = Rack::MockRequest.env_for("www.name.com")
    env["CONTENT_TYPE"] = "unknown"
    env[Rack::RACK_INPUT] = StringIO.new(body)
    _code, _headers, body = Jwtoken::Middleware.new(app).call(env)
    expect(body).to eq([nil])
  end
end
