require './app.rb'

rackapp = Rack::Builder.app do
  use Prometheus::Middleware::Collector

  map '/metrics' do
    use Rack::Auth::Basic, 'Prometheus Metrics' do |username, password|
      Rack::Utils.secure_compare(ENV['CROWDAI_API_KEY'], password)
    end
    use Rack::Deflater
    use Prometheus::Middleware::Exporter, path: ''
    run ->(_) { [500, { 'Content-Type' => 'text/html' }, ['crowdAI metrics endpoint is unreachable!']] }
  end
  run Sinatra::Application
end
run rackapp
