require "tailwindcss-rails"

NO_PASSWORD_TAILWIND_COMPILE_COMMAND = "#{Tailwindcss::Engine.root.join("exe/tailwindcss")} -i #{NoPassword::Engine.root.join("app/assets/stylesheets/no_password/application.tailwind.css")} -o #{Rails.root.join("app/assets/builds", "no_password/tailwind.css")} -c #{Rails.root.join("app/assets/config/no_password/tailwind.config.js")}"

namespace :no_password do
  namespace :tailwindcss do
    desc "Build your Tailwind CSS"
    task :build do
      Rails::Generators.invoke("no_password:tailwind_config", ["--force"])
      system NO_PASSWORD_TAILWIND_COMPILE_COMMAND
    end

    desc "Watch and build your Tailwind CSS"
    task :watch do
      Rails::Generators.invoke("no_password:tailwind_config", ["--force"])
      system "#{NO_PASSWORD_TAILWIND_COMPILE_COMMAND} -w"
    end
  end
end

if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance(["no_password:tailwind:build"])
end
