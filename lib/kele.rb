require 'httparty'
require 'json'

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
  
  def get_me
    response = self.class.get('/users/me', headers: {"authorization" => @auth})
    JSON.parse response.body
  end
  
  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: {"authorization" => @auth})
    JSON.parse(response.body)
  end
end