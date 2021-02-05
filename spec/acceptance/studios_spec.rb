require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Studios' do

  header 'Authorization', :custom_header

  get '/api/v1/studios' do
    parameter :target, 'The thing you want to greet'
    example 'Listing studios' do
      do_request target: 'rspec_api_documentation'
      expect(status).to eq 200
    end
  end

  post '/api/v1/studios' do
    let(:user) do
      User.create(email: 'jamie@g.com', role: 'Admin', full_name: 'Jamie', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    context '201' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }

      example 'Successfully create studio' do
        request = {
          user_id: user[:id],
          email: 'inky@ink.com',
          name: 'Inky Ink Studio',
          bio: 'Blackity black black',
          city: 'Kisumu',
          country: 'Kenya'

        }

        do_request(request)
        result = parse(response_body)

        expected_response = {
          id: result['id'],
          user_id: user[:id],
          name: 'Inky Ink Studio',
          bio: 'Blackity black black',
          city: 'Kisumu',
          state: nil,
          street_address: nil,
          zip_code: nil,
          country: 'Kenya',
          phone_number: nil,
          specialty: nil,
          accepted_payment_methods: nil,
          appointment_only: false,
          languages: nil,
          services: nil,
          email: 'inky@ink.com',
          facebook_url: nil,
          twitter_url: nil,
          instagram_url: nil,
          website_url: nil,
          lat: nil,
          lon: nil,
          status: nil,
          slug: nil,
          accepting_guest_artist: false,
          piercings: false,
          cosmetic_tattoos: true,
          vegan_ink: false,
          wifi: true,
          privacy_dividers: false,
          wheelchair_access: false,
          parking: false,
          lgbt_friendly: true,
          price_per_hour: nil,
          artists: []
        }

        expect(status).to eq(201)
        expect(result).to eq(parse(expected_response.to_json))
      end
    end

    context '422' do

      example 'Create studios without token' do
        request = {
          email: 'inky@ink.com',
          name: 'Inky Ink Studio',
          bio: 'Blackity black black',
          city: 'Kisumu',
          country: 'Kenya'

        }


        do_request(request)
        expect(status).to eq(422)
      end
    end
  end

  get '/api/v1/studios/:id' do
    let(:user) do
      User.create(email: 'jamie@g.com', role: 'Admin', full_name: 'Jamie', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    let(:studio) do
      Studio.create(user_id: user[:id], email: 'inky@ink.com')
    end

    context '200' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { studio[:id] }

      example 'Successfully get studio' do

        do_request
        result = parse(response_body)

        expected_response = {
          id: result['id'],
          user_id: user[:id],
          name: nil,
          bio: nil,
          city: nil,
          state: nil,
          street_address: nil,
          zip_code: nil,
          country: nil,
          phone_number: nil,
          specialty: nil,
          accepted_payment_methods: nil,
          appointment_only: false,
          languages: nil,
          services: nil,
          email: 'inky@ink.com',
          facebook_url: nil,
          twitter_url: nil,
          instagram_url: nil,
          website_url: nil,
          lat: nil,
          lon: nil,
          status: nil,
          slug: nil,
          accepting_guest_artist: false,
          piercings: false,
          cosmetic_tattoos: true,
          vegan_ink: false,
          wifi: true,
          privacy_dividers: false,
          wheelchair_access: false,
          parking: false,
          lgbt_friendly: true,
          price_per_hour: nil,
          artists: []
        }

        expect(status).to eq(200)
        expect(result).to eq(parse(expected_response.to_json))
      end
    end

    context '404' do
      let(:id) { 1 }

      example 'Studio not found' do
        do_request
        expect(status).to eq(404)
      end
    end
  end

  put '/api/v1/studios/:id' do
    let(:user) do
      User.create(email: 'jamie@g.com', role: 'Admin', full_name: 'Jamie', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    let(:studio) do
      Studio.create(user_id: user[:id], email: 'inky@ink.com', bio: 'Blackity black black')
    end

    context '200' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { studio[:id] }

      example 'Successfully update studio' do

        request = {
          email: 'jenkins@ink.com'
        }

        do_request(request)
        result = parse(response_body)

        expected_response = {
          id: result['id'],
          user_id: user[:id],
          name: nil,
          bio: 'Blackity black black',
          city: nil,
          state: nil,
          street_address: nil,
          zip_code: nil,
          country: nil,
          phone_number: nil,
          specialty: nil,
          accepted_payment_methods: nil,
          appointment_only: false,
          languages: nil,
          services: nil,
          email: 'jenkins@ink.com',
          facebook_url: nil,
          twitter_url: nil,
          instagram_url: nil,
          website_url: nil,
          lat: nil,
          lon: nil,
          status: nil,
          slug: nil,
          accepting_guest_artist: false,
          piercings: false,
          cosmetic_tattoos: true,
          vegan_ink: false,
          wifi: true,
          privacy_dividers: false,
          wheelchair_access: false,
          parking: false,
          lgbt_friendly: true,
          price_per_hour: nil,
          artists: []
        }

        expect(status).to eq(200)
        expect(result).to eq(parse(expected_response.to_json))
      end
    end

    context '404' do
      let(:custom_header) { "Token #{JsonWebToken.encode(user_id: user[:id])}" }
      let(:id) { 1 }

      example 'Studio not found' do

        request = {
          email: 'jenkins@ink.com'
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
