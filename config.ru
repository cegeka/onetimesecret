require './app.rb'
require './basic_auth_metrics.rb'

run Sinatra::Application

app = lambda do |env|
  # Your application logic here
  [200, {'Content-Type' => 'text/plain'}, ['Hello, World!']]
end

use AuthBasicMetrics, username: 'admin', password: 'password', realm: 'Restricted Area'

run app
