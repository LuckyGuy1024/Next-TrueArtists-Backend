require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Tattoos' do

  header 'Authorization', :custom_header

  get '/api/v1/tattoos' do
    parameter :target, 'The thing you want to greet'
    example 'Listing tattoos' do
      do_request target: 'rspec_api_documentation'
      expect(status).to eq 200
    end
  end

  get '/api/v1/tattoos/:id' do
    let(:user) do
      User.create(email: 'jamie@g.com', role: 'Admin', full_name: 'Jamie', status: true, password: 'Myname123',
                  password_confirmation: 'Myname123')
    end

    let(:artist) do
      Artist.create(user_id: user[:id], years_of_experience: 3)
    end

    let(:studio) do
      Studio.create(user_id: user[:id], email: 'inky@ink.com', bio: 'Blackity black black')
    end

    let(:tattoo) do
      Tattoo.create(color: "Black",
                    artist_id: artist[:id], studio_id: studio[:id])
    end

    context '200' do
      let(:id) { tattoo[:id] }

      example 'Successfully get tattoo' do

        do_request

        expect(status).to eq(200)
      end
    end

    context '404' do
      let(:id) { 1 }

      example 'Tattoo not found' do
        do_request
        expect(status).to eq(404)
      end
    end
  end

  def parse(response)
    JSON.parse response
  end
end
