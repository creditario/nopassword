# frozen_string_literal: true

module PrintRoutes
  def print_routes
    puts "ROUTES  ----------------------"
    Rails.application.routes.routes.each do |r|
      route = {alias: r.name, path: r.path.spec.to_s, controller: r.defaults[:controller], action: r.defaults[:action]}
      puts route
    end
    puts "------------------------------"
  end
end
