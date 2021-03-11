require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Artists' do

  header 'Authorization', :custom_header

  get '/api/v1/artists' do
    parameter :target, 'The thing you want to greet'
    example 'Listing artists' do
      do_request target: 'rspec_api_documentation'
      expect(status).to eq 200
    end
  end

  post '/api/v1/artists' do
    let(:user) do
      User.create(email: 'jamie@g.com', role: 'Admin', full_name: 'Jamie', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    with_options with_example: true do
      parameter :licensed
      parameter :years_of_experience
      parameter :styles
      parameter :website
      parameter :facebook_url
      parameter :twitter_url
      parameter :instagram_url
      parameter :phone_number
      parameter :minimum_spend
      parameter :price_per_hour
      parameter :currency_code
      parameter :street_address
      parameter :city
      parameter :state
      parameter :zip_code
      parameter :country
      parameter :seeking_guest_spot
      parameter :guest_artist
    end

    context '201' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }

      example 'Successfully create artists' do
        request = {
          user_id: user[:id],
          licenced: 'yes',
          years_of_experience: '3',
          city: 'Kisumu',
          country: 'Kenya'
        }

        do_request(request)
        result = parse(response_body)

        expect(status).to eq(201)
      end
    end

    context '401' do

      example 'Create artists without token' do
        request = {
          user_id: user[:id],
          licenced: 'yes',
          years_of_experience: '3',
          city: 'Kisumu',
          country: 'Kenya'

        }

        # It's also possible to extract types of parameters when you pass data through `do_request` method.
        do_request(request)
        expect(status).to eq(401)
      end
    end
  end

  get '/api/v1/artists/:id' do
    let(:user) do
      User.create(email: 'jamie@g.com', role: 'Admin', full_name: 'Jamie', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    let(:artist) do
      Artist.create(user_id: user[:id], years_of_experience: 3)
    end

    context '200' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { artist[:id] }

      example 'Successfully get artists' do

        do_request
        result = parse(response_body)


        expect(status).to eq(200)
      end
    end

    context '404' do
      let(:id) { 1 }

      example 'Artist not found' do
        do_request
        expect(status).to eq(404)
      end
    end
  end

  put '/api/v1/artists/:id' do
    let(:user) do
      User.create(email: 'jamie@g.com', role: 'Admin', full_name: 'Jamie', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    let(:artist) do
      Artist.create(user_id: user[:id], years_of_experience: 3)
    end

    context '200' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { artist[:id] }

      example 'Successfully update artist' do

        request = {
          years_of_experience: '5',
          city: 'Kisumu',
          country: 'Kenya'
        }

        do_request(request)
        result = parse(response_body)

        expect(status).to eq(200)
      end
    end

    context '404' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { 1 }

      example 'Artist not found' do

        request = {
          years_of_experience: '5',
          city: 'Kisumu',
          country: 'Kenya'
        }

        do_request(request)

        expect(status).to eq(404)
      end
    end
  end

  def parse(response)
    JSON.parse response
  end
end
