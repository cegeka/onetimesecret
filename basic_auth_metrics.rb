class AuthBasicMetrics
  def initialize(app, opts = {})
    @app = app
    @username = opts[:username]
    @password = opts[:password]
    @realm = opts[:realm] || 'Restricted Area'
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.path == '/metrics'
      authenticate(env)
    else
      @app.call(env)
    end
  end

  private

  def authenticate(env)
    auth = Rack::Auth::Basic::Request.new(env)

    unless auth.provided? && auth.basic? && auth.credentials == [@username, @password]
      unauthorized
    end

    @app.call(env)
  end

  def unauthorized
    headers = {
      'Content-Type' => 'text/plain',
      'Content-Length' => '0',
      'WWW-Authenticate' => "Basic realm=\"#{@realm}\""
    }

    [401, headers, []]
  end
end
