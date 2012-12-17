require './models/models.rb'
require 'sinatra'

require './helpers/helpers'


if development?
  puts 'DEVELOPMENT'
  require 'sinatra/reloader'
end

before do
  @authuser = User.get get_login

  p 'page loading: ' + request.fullpath
  if @authuser
    p '@authuser = ' + @authuser.name
  else
    p '@authuser = nil'
  end

  p 'Params:'
  params.each do |param|
    p param
  end
end

# AJAX #

get "/api/test" do
  json :a => 1, :b => 2
end


get '/' do
  erb :index
end

# User Auth ####

get "/logout" do
  logout
  redirect '/'
end

get "/signup" do 
  erb :signup
end

get "/login" do
  erb :login
end

post "/signup" do 
  salt = Time.now.to_s
  u = User.create(:name => params[:name],
              :salt => salt, 
              :password => password_hash(salt, params[:password])
              )
  if u.saved?
    login u.id
    redirect '/'
  else
    u.errors.each do |e|
      p e
    end
    "Registration failed"
  end
end

post "/login" do
  u = User.first(:name_lower => params[:name].downcase)
  if u and verify_pass(u, params[:password])
    login(u.id)
    redirect '/'
  elsif u
    p 'invalid password'
    "Invalid username or password"
  else
    p 'invalid username'
    "Invalid username or password"
  end
end
