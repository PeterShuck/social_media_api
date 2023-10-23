# Abstractable class leveraging Faraday to establish github connection, based off of
# https://medium.com/@agungsetiawan/creating-faraday-gem-abstraction-in-our-rails-project-7a36082a2422
class Connection
  def self.third_party_api(*args)
    self.faraday(*args) do |f|
      f.headers['Content-Type'] = 'application/json'
      f.options.open_timeout = 10
      f.options.timeout      = 20
    end
  end

  def self.faraday(*args)
    Faraday.new(*args) do |f|
      yield(f) if block_given?
    end
  end
end
