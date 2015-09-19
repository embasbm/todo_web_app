DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/todo_list.db")

# models will go here
class Task
  include DataMapper::Resource
  property :id, Serial
  property :description, Text
  property :completed, Boolean, default: false
  property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!

class TodoApp < Sinatra::Base
  set :erb, escape_html: true

  configure :development do
    register Sinatra::Reloader
  end

  # example route, access this with http://localhost:9292/example
  get '/todos' do
    erb :todos
  end

  # add more routes here
end