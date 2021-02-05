require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Sessions' do

  post '/api/v1/sessions/login' do
    let(:user) do
      User.create(email: 'ramon@g.com', role: 'Admin', full_name: 'Ramon', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    xcontext '200' do
      example 'Successfully login' do
        request = {
          email: 'ramon@g.com',
          password: 'Myname123'
        }

        do_request(request)
        expect(status).to eq(200)
      end
    end

    context '401' do

      example 'Invalid user' do
        request = {
          email: 'ramzy@g.com',
          password: 'ramon1234'

        }

        do_request(request)
        expect(status).to eq(401)
      end
    end
  end

  def parse(response)
    JSON.parse response
  end
end
