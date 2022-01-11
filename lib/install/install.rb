say "Installing no password assets in host app\n\n"

say "TailwindCSS config file to app/assets/stylesheets/no_password"
empty_directory "app/assets/stylesheets/no_password"
copy_file %Q[#{File.join(NoPassword::Engine.root, "app", "assets", "stylesheets", "config.css")}], %Q[#{File.join(Rails.root, "app", "assets", "stylesheets", "no_password", "config.css")}]
say "Don't forget to import ./no_password/config.css into your application.css", :green

say "\n\nStimulus controllers to app/javascript/no_password/controllers"
empty_directory "app/javascript/no_password"
directory %Q[#{File.join(NoPassword::Engine.root, "app", "javascript", "controllers")}], %Q[#{File.join(Rails.root, "app", "javascript", "no_password", "controllers")}]
say "Don't forget to include .no_password/controllers into your application.js", :green
