require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap
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
  
  def get_messages(page = nil)
    response = self.class.get("/message_threads", body: {"page": page}, headers: {"authorization" => @auth})
    JSON.parse(response.body)
  end
  
  def create_message(sender, recipient_id, subject, text)
    response = self.class.post("/messages", body: {"sender": @email, "recipient_id": recipient_id, "subject": subject, "stripped-text": text}, headers: {authorization: @auth})
    JSON.parse(response.body)
  end
end