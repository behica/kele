require 'httparty'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'
  
  def initialize(email, password)
    response = self.class.post('/sessions', body: {"email": email, "password": password})
    case response.code
      when 200
        puts "All good!"
      when 404
        puts "Invalid credentials! Try again."
      when 500...600
        puts "ZOMG ERROR #{response.code}"
    end
    
    @auth = response['auth_token']
  end
end