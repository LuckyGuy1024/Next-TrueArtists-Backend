require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do

  header 'Authorization', :custom_header

  post '/api/v1/users' do

    context '201' do
      example 'Successfully create user' do
        request = {
          email: 'ramon@g.com',
          role: 'Admin',
          full_name: 'Ramon Omondi',
          status: true,
          password: 'ramon1234',
          password_confirmation: 'ramon1234'

        }

        do_request(request)
        result = parse(response_body)

        expected_response = {
          id: result['id'],
          email: 'ramon@g.com',
          role: 'Admin',
          status: true
        }

        expect(status).to eq(201)
        expect(result).to eq(parse(expected_response.to_json))
      end
    end

    context '422' do

      example 'Create artists without email' do
        request = {
          role: 'Admin',
          full_name: 'Ramon Omondi',
          status: true,
          password: 'ramon1234',
          password_confirmation: 'ramon1234'

        }

        do_request(request)
        expect(status).to eq(422)
      end
    end
  end

  get '/api/v1/users/:id' do
    let(:user) do
      User.create(email: 'ramon@g.com', role: 'Admin', full_name: 'Ramon', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    context '200' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { user[:id] }

      example 'Successfully get user' do

        do_request
        result = parse(response_body)

        expected_response = {
          id: result['id'],
          email: 'ramon@g.com',
          role: 'Admin',
          status: true
        }

        expect(status).to eq(200)
        expect(result).to eq(parse(expected_response.to_json))
      end
    end

    context '401' do
      let(:id) { 1 }

      example 'Unauthorised to make this request' do
        do_request
        expect(status).to eq(401)
      end
    end
  end

  put '/api/v1/users/:id' do
    let(:user) do
      User.create(email: 'ramon@g.com', role: 'Admin', full_name: 'Ramon', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    context '200' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { user[:id] }

      example 'Successfully update user' do

        request = {
          user: {
            email: 'jimmyjam@gmail.com'
          }
        }

        do_request(request)
        result = parse(response_body)

        expected_response = {
          id: result['id'],
          email: 'jimmyjam@gmail.com',
          full_name: 'Ramon',
          role: 'regular',
          status: 'active'
        }

        expect(status).to eq(200)
        expect(result).to eq(parse(expected_response.to_json))
      end
    end


    context '401' do
      let(:id) { user[:id] }

      example 'Unauthorised to make this request' do
        request = {
          user: {
            email: 'jimmyjam@gmail.com'
          }
        }

        do_request(request)
        expect(status).to eq(401)
      end
    end
  end

  delete '/api/v1/users/:id' do
    let(:user) do
      User.create(email: 'ramon@g.com', role: 'Admin', full_name: 'Ramon', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    context '200' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { user[:id] }

      example 'Successfully destroy user' do
        do_request

        expect(status).to eq(200)
      end
    end

    context '401' do
      let(:id) { user[:id] }

      example 'Unauthorised to make this request' do
        do_request

        expect(status).to eq(401)
      end
    end
  end

  def parse(response)
    JSON.parse response
  end
end
