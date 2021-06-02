# frozen_string_literal: true

require 'faker'

puts '== Seeding the database =='
puts "\n== Creating Admin user data =="

# ['Free Style', 'Free Hand', 'Black & White', 'Color', 'Japanase', 'Freehand'].each do |s|
#   Style.create(name: s)
# end

if ENV['RUN_ALL'] == '1'
  # 5.times do |i|
  #   User.create(
  #     email: "admin#{i + 1}@example.com",
  #     role: 'admin',
  #     full_name: Faker::Name.name,
  #     password: 'pass1234',
  #     password_confirmation: 'pass1234'
  #   )
  # end

  # puts "\n== Creating regular_user data =="

  # 1500.times do |i|
  #   User.create(
  #     email: "ta#{i + 1}@example.com",
  #     full_name: Faker::Name.name,
  #     password: 'pass1234',
  #     password_confirmation: 'pass1234'
  #   )
  # end

  # puts "\n== Creating studio data =="

  # 500.times do |i|
  #   studio = Studio.create(
  #     user_id: i + 6,
  #     email: Faker::Internet.safe_email,
  #     name: Faker::Name.name,
  #     bio: Faker::Lorem.sentence,
  #     website_url: Faker::Internet.url,
  #     facebook_url: Faker::Internet.url(host: 'facebook.com'),
  #     twitter_url: Faker::Internet.url(host: 'twitter.com'),
  #     instagram_url: Faker::Internet.url(host: 'instagram.com'),
  #     minimum_spend: 30,
  #     price_per_hour: 30,
  #     city: Faker::Address.city
  #   )

  #   studio.avatar.attach(
  #     io: File.open('app/assets/images/avatar.png'),
  #     filename: 'avatar.png'
  #   )

  #   studio.hero_banner.attach(
  #     io: File.open('app/assets/images/hero_banner.jpg'),
  #     filename: 'hero_banner.jpg'
  #   )
  # end

  # puts "\n== Creating artist data =="

  # 500.times do |i|
  #   artist = Artist.create(
  #     user_id: i + 506,
  #     licensed: true,
  #     years_of_experience: Faker::Number.number(digits: 1),
  #     bio: Faker::Lorem.sentence,
  #     website: Faker::Internet.url,
  #     facebook_url: Faker::Internet.url(host: 'facebook.com'),
  #     twitter_url: Faker::Internet.url(host: 'twitter.com'),
  #     instagram_url: Faker::Internet.url(host: 'instagram.com'),
  #     minimum_spend: 30,
  #     price_per_hour: 30,
  #     currency_code: 'USD',
  #     city: Faker::Address.city
  #   )

  #   artist.avatar.attach(
  #     io: File.open('app/assets/images/avatar.png'),
  #     filename: 'avatar.png'
  #   )

  #   artist.hero_banner.attach(
  #     io: File.open('app/assets/images/hero_banner.jpg'),
  #     filename: 'hero_banner.jpg'
  #   )
  # end

  # puts "\n== Creating studio_artist data =="

  # 250.times do |i|
  #   StudioArtist.create(
  #     artist_id: i + 1,
  #     studio_id: i + 251,
  #     start_date: Time.now
  #   )
  # end

  puts "\n== Creating artist tattoos data =="
  50.times do |i|
    artist_tattoo = Tattoo.create(
      artist_id: i + 1,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['artist', 'tattoo', 'artist tattoo']
    )

    artist_tattoo.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  50.times do |i|
    artist_tattoo = Tattoo.create(
      artist_id: i + 50,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['artist', 'tattoo', 'artist tattoo']
    )

    artist_tattoo.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  50.times do |i|
    artist_tattoo = Tattoo.create(
      artist_id: i + 100,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['artist', 'tattoo', 'artist tattoo']
    )

    artist_tattoo.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  50.times do |i|
    artist_tattoo = Tattoo.create(
      artist_id: i + 150,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['artist', 'tattoo', 'artist tattoo']
    )

    artist_tattoo.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  puts "\n== Creating studio tattoos data =="
  50.times do |i|
    studio_tattoo = Tattoo.create(
      studio_id: i + 1,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['studio', 'tattoo', 'studio tattoo']
    )

    studio_tattoo.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  50.times do |i|
    studio_tattoo = Tattoo.create(
      studio_id: i + 50,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['studio', 'tattoo', 'studio tattoo']
    )

    studio_tattoo.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  50.times do |i|
    studio_tattoo = Tattoo.create(
      studio_id: i + 100,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['studio', 'tattoo', 'studio tattoo']
    )

    studio_tattoo.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  50.times do |i|
    studio_tattoo = Tattoo.create(
      studio_id: i + 150,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['studio', 'tattoo', 'studio tattoo']
    )

    studio_tattoo.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  puts "\n== Creating categories =="

  20.times do
    Category.create(
      name: Faker::Lorem.sentence,
      meta_description: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph(sentence_count: 4),
      status: %w[draft published flagged].sample
    )
  end

  puts "\n== Creating articles =="

  200.times do
    article = Article.create(
      user_id: [1, 2, 3, 4, 5].sample,
      title: Faker::Lorem.sentence,
      page_title: Faker::Lorem.sentence,
      meta_description: Faker::Lorem.sentence,
      tag_list: ['artist', 'tattoo', 'artist tattoo'],
      introduction: Faker::Lorem.paragraph(sentence_count: 9),
      content: Faker::Lorem.paragraph(sentence_count: 40),
      status: %w[draft published flagged].sample,
      category_id: [*1..20].sample
    )

    article.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  200.times do
    article = Article.create(
      user_id: [1, 2, 3, 4, 5].sample,
      title: Faker::Lorem.sentence,
      page_title: Faker::Lorem.sentence,
      meta_description: Faker::Lorem.sentence,
      tag_list: ['artist', 'tattoo', 'artist tattoo'],
      introduction: Faker::Lorem.paragraph(sentence_count: 9),
      content: Faker::Lorem.paragraph(sentence_count: 40),
      status: %w[draft published flagged].sample,
      category_id: [*1..20].sample
    )

    article.image.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end

  200.times do
    landing_page = LandingPage.create(
      page_key: "/artists/#{Faker::FunnyName.name}",
      last_updated_by: [1, 2, 3, 4, 5].sample,
      title: Faker::Lorem.sentence,
      page_title: Faker::Lorem.sentence,
      meta_description: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph(sentence_count: 40),
      status: %w[draft published].sample,
    )

    landing_page.avatar.attach(
      io: File.open('app/assets/images/g1.jpg'),
      filename: 'image.jpg'
    )
  end


  puts '== Creating conventions =='

  40.times do
    conventions = Convention.create(
      name: Faker::FunnyName.name,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      address: Faker::Address.street_address,
      country: Faker::Address.country,
      city: Faker::Address.city,
      state: Faker::Address.state,
      start_date: Faker::Date.between(from: '2021-05-25', to: '2021-06-25'),
      end_date: Faker::Date.between(from: '2021-05-26', to: '2021-06-30'),
      created_by: [1, 2, 3, 4, 5].sample,
      link_to_official_site: Faker::Internet.url,
      facebook_link: Faker::Internet.url(host: 'facebook.com')
    )

    conventions.image.attach(
      io: File.open('app/assets/images/avatar.png'),
      filename: 'avatar.png'
    )
  end
end
