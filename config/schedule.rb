env :MAILTO, 'james@trueartists.com'
set :output, 'log/cron.log'

case @environment
when 'production'
  every [:wednesday], at: Time.parse('4pm').getlocal.strftime('%H:%M'), roles: [:app] do
    rake 'tattoo_upload:reminder --trace'
  end

  every 24.hours, at: Time.parse('2pm').getlocal.strftime('%H:%M'), roles: [:app] do
    rake 'onboarding:reminders --trace'
  end
end
