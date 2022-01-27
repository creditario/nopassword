namespace :no_password do
  desc "Install No Password"
  task install: :environment do
    ActiveRecord::Base.connection
  rescue ActiveRecord::NoDatabaseError
    puts "ERROR: database does not exist, run 'rails db:create' first"
  else
    Rails::Command.invoke :generate, ["no_password:install"]
  end

  namespace :install do
    desc "Copy templates from no_password to application"
    task copy_templates: :environment do
      Rails::Command.invoke :generate, ["no_password:install_templates"]
    end
  end
end
