# Jwtoken

Rack middleware that reads a JWT from the request body and attaches it to the `Authorization` header.  Useful for when your Single Page Application (SPA) needs to authentiate with a Ruby backend, but you're not able to send the token in the `Authorization` header. E.g. HTML forms, `navigator.sendBeacon`, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jwtoken'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jwtoken

## Usage

### Rails

Add `Jwtoken::Middleware` to beginning of middleware stack:

*environment.rb*
`config.middleware.insert_before 1, Jwtoken::Middleware`

### Requests

Jwtoken currently supports two Content-Types, where the request body includes the jwt_token:

1. 'Content-Type': 'application/json'
    * { jwt_token: "Bearer efgxyz"}

2. 'Content-Type': 'application/x-www-form-urlencoded'

    * 'jwt_token=Bearer+efgxyz'

Given your request Content-Type header is one of the above and the body includes jwt_token as seen above your Rack Api will see the JWT correctly included in the Authorization header: *Authorization: 'Bearer efgxyz'*

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests welcome!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
