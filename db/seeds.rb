# frozen_string_literal: true

require 'faker'

puts '== Seeding the database =='
puts "\n== Creating Admin user data =="

5.times do |i|
  User.create(
    email: "admin#{i + 1}@example.com",
    role: 'admin',
    full_name: Faker::Name.name,
    password: 'pass1234',
    password_confirmation: 'pass1234'
  )
end

puts "\n== Creating regular_user data =="

1500.times do |i|
  User.create(
    email: "ta#{i + 1}@example.com",
    full_name: Faker::Name.name,
    password: 'pass1234',
    password_confirmation: 'pass1234'
  )
end

puts "\n== Creating studio data =="

500.times do |i|
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
    city: Faker::Address.city
  )

  studio.avatar.attach(
    io: File.open('app/assets/images/avatar.png'),
    filename: 'avatar.png'
  )

  studio.hero_banner.attach(
    io: File.open('app/assets/images/hero_banner.jpg'),
    filename: 'hero_banner.jpg'
  )
end

puts "\n== Creating artist data =="

500.times do |i|
  artist = Artist.create(
    user_id: i + 506,
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
    city: Faker::Address.city
  )

  artist.avatar.attach(
    io: File.open('app/assets/images/avatar.png'),
    filename: 'avatar.png'
  )

  artist.hero_banner.attach(
    io: File.open('app/assets/images/hero_banner.jpg'),
    filename: 'hero_banner.jpg'
  )
end

puts "\n== Creating studio_artist data =="

250.times do |i|
  StudioArtist.create(
    artist_id: i + 1,
    studio_id: i + 251,
    start_date: Time.now
  )
end

puts "\n== Creating artist tattoos data =="

250.times do |i|
  artist_tattoo = Tattoo.create(
    artist_id: i + 1,
    placement: 'back',
    size: 'small',
    color: Faker::Color.color_name
  )

  artist_tattoo.image.attach(
    io: File.open('app/assets/images/image.jpg'),
    filename: 'image.jpg'
  )
end

puts "\n== Creating studio tattoos data =="

250.times do |i|
  studio_tattoo = Tattoo.create(
    studio_id: i + 251,
    placement: 'back',
    size: 'small',
    color: Faker::Color.color_name
  )

  studio_tattoo.image.attach(
    io: File.open('app/assets/images/image.jpg'),
    filename: 'image.jpg'
  )
end

puts "\n== Finished =="
