namespace :no_password do
  namespace :install do
    desc "Install no password"
    task :assets do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/install.rb", __dir__)}"
    end
  end
end
