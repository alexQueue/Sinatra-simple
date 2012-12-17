helpers do
  require 'digest/sha2'
  include Rack::Utils
  
  alias_method :h, :escape_html

  # Useful things I tend to use
  def partial(name, options = {})
    erb :"partials/#{name}", options.merge!(:layout => false)
  end

  def json(o)
    content_type :json
    o.to_json
  end



  # User auth
  def session_id
    Digest::SHA2.hexdigest("Unique salt 1 " + request.ip)
  end

  def cookie(k, v)
    response.set_cookie k, :value => v, :path => '/', :expires => Time.now + 60 * 60 * 24 * 365 * 20
  end

  def login_hash(id)
    Digest::SHA2.hexdigest("Unique salt 2 " + id.to_s)
  end

  def login(id)
    p "logging in user: " + id.to_s

    cookie "login_id", id
    cookie "login_hash", login_hash(id)
  end

  def get_login
    id = request.cookies["login_id"]
    hash = request.cookies["login_hash"]
    
    if login_hash(id) == hash
      id
    else
      nil
    end
  end

  def logout
    cookie "login_id", nil
    cookie "login_hash", nil
  end

  def logged_in_user
    id = request.cookies["login_id"]
    hash = request.cookies["login_hash"]
    
    if login_hash(id) == hash
      User.first(:id => id)
    else
      nil
    end
  end

  def password_hash(salt, password)
     Digest::SHA2.hexdigest(salt + password + " Unique salt 3").to_s
  end

  def verify_pass(user, password) 
    user.password == password_hash(user.salt, password)
  end

end