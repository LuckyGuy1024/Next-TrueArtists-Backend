env :MAILTO, 'jamomathenge@gmail.com'
set :output, 'log/cron.log'
# job_type :rake, 'cd :path && PATH=/usr/local/bin:$PATH RAILS_ENV=:environment bundle exec rake :task :output'

every 2.hours do
  rake 'import:legacy_data --trace'
end

every [:wednesday], at: Time.parse('4pm').getlocal.strftime('%H:%M') do
  rake 'send_tattoo_upload_email:reminder --trace'
end

every 24.hours, at: Time.parse('2pm').getlocal.strftime('%H:%M') do
  rake 'complete_profile_schedule:reminder --trace'
end
