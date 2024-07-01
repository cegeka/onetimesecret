require './app.rb'
require './basic_auth_metrics.rb'

run Sinatra::Application

use AuthBasicMetrics, username: 'admin', password: 'password', realm: 'Restricted Area'

