set :output, "log/cron.log"
set :job_template, nil if ENV.fetch("RAILS_ENV", "development") == "development"
set :environment, ENV.fetch("RAILS_ENV")

every 1.hour do
 
end