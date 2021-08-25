# frozen_string_literal: true

require 'faker'

puts '== Seeding the database =='

['Free Style', 'Free Hand', 'Black & White', 'Color', 'Japanase', 'Freehand'].each do |s|
  Style.create(name: s)
end

if ENV['RUN_ALL'] == '1'
  puts "\n== Creating admin user data =="
  5.times do |i|
    User.create(
      email: "admin#{i + 1}@example.com",
      role: 'admin',
      full_name: Faker::Name.name,
      password: 'pass1234',
      password_confirmation: 'pass1234'
    )
  end

  puts "\n== Creating regular user data =="

  300.times do |i|
    User.create(
      email: "ta#{i + 1}@example.com",
      full_name: Faker::Name.name,
      password: 'pass1234',
      password_confirmation: 'pass1234'
    )
  end

  puts "\n== Creating studio data =="

  100.times do |i|
    studio = Studio.create(
      user_id: i + 6,
      email: Faker::Internet.safe_email,
      name: Faker::Name.name,
      bio: Faker::Lorem.sentence,
      website_url: Faker::Internet.url,
      facebook_url: Faker::Internet.url(host: 'facebook.com'),
      twitter_url: Faker::Internet.url(host: 'twitter.com'),
      instagram_url: Faker::Internet.url(host: 'instagram.com'),
      minimum_spend: 30,
      price_per_hour: 30,
      status: ['pending_review', 'approved'].sample,
      city: Faker::Address.city
    )

    studio.avatar.attach(
      io: File.open('app/assets/images/avatar.png'),
      filename: 'avatar.png'
    )
  end

  puts "\n== Creating artist data =="

  100.times do |i|
    artist = Artist.create(
      user_id: i + 206,
      licensed: true,
      years_of_experience: Faker::Number.number(digits: 1),
      bio: Faker::Lorem.sentence,
      website: Faker::Internet.url,
      facebook_url: Faker::Internet.url(host: 'facebook.com'),
      twitter_url: Faker::Internet.url(host: 'twitter.com'),
      instagram_url: Faker::Internet.url(host: 'instagram.com'),
      minimum_spend: 30,
      price_per_hour: 30,
      currency_code: 'USD',
      status: ['pending_review', 'approved'].sample,
      city: Faker::Address.city
    )

    artist.avatar.attach(
      io: File.open('app/assets/images/avatar.png'),
      filename: 'avatar.png'
    )
  end

  puts "\n== Creating studio_artist data =="

  50.times do |i|
    StudioArtist.create(
      artist_id: Artist.pluck(:id).sample,
      studio_id: Studio.pluck(:id).sample,
      start_date: Time.now
    )
  end

  puts "\n== Creating artist tattoos data =="
  20.times do |i|
    artist_tattoo = Tattoo.create(
      artist_id: Artist.pluck(:id).sample,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['artist', 'tattoo', 'artist tattoo']
    )

    artist_tattoo.image.attach(
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
    )
  end

  20.times do |i|
    artist_tattoo = Tattoo.create(
      artist_id: Artist.pluck(:id).sample,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['artist', 'tattoo', 'artist tattoo']
    )

    artist_tattoo.image.attach(
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
    )
  end

  20.times do |i|
    artist_tattoo = Tattoo.create(
      artist_id: Artist.pluck(:id).sample,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['artist', 'tattoo', 'artist tattoo']
    )

    artist_tattoo.image.attach(
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
    )
  end

  20.times do |i|
    artist_tattoo = Tattoo.create(
      artist_id: Artist.pluck(:id).sample,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['artist', 'tattoo', 'artist tattoo']
    )

    artist_tattoo.image.attach(
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
    )
  end

  puts "\n== Creating studio tattoos data =="
  20.times do |i|
    studio_tattoo = Tattoo.create(
      studio_id: Studio.pluck(:id).sample,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['studio', 'tattoo', 'studio tattoo']
    )

    studio_tattoo.image.attach(
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
    )
  end

  20.times do |i|
    studio_tattoo = Tattoo.create(
      studio_id: Studio.pluck(:id).sample,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['studio', 'tattoo', 'studio tattoo']
    )

    studio_tattoo.image.attach(
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
    )
  end

  20.times do |i|
    studio_tattoo = Tattoo.create(
      studio_id: Studio.pluck(:id).sample,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['studio', 'tattoo', 'studio tattoo']
    )

    studio_tattoo.image.attach(
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
    )
  end

  20.times do |i|
    studio_tattoo = Tattoo.create(
      studio_id: Studio.pluck(:id).sample,
      placement: 'back',
      size: 'small',
      color: Faker::Color.color_name,
      tag_list: ['studio', 'tattoo', 'studio tattoo']
    )

    studio_tattoo.image.attach(
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
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

  30.times do
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
      io: File.open("lib/tasks/sample_data/images/#{[1, 2, 3].sample}.jpeg"),
      filename: 'image.jpeg'
    )
  end
end
