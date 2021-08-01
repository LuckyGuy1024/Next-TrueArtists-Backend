env :MAILTO, 'jamomathenge@gmail.com'
set :output, 'log/cron.log'
# job_type :rake, 'cd :path && PATH=/usr/local/bin:$PATH RAILS_ENV=:environment bundle exec rake :task :output'

every 2.hours do
  rake "import:legacy_data --trace"
end
