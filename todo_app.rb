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
    @tasks = Task.all(order: :created_at.desc)
    erb :todos
  end

  post '/todos' do
    Task.create(description: params[:description], created_at: Time.now)
    redirect '/todos'
  end

  post '/todos/:id/complete' do
    task = Task.get(params[:id])
    task.update(completed: true)
  end
  post '/todos/:id/uncomplete' do
    task = Task.get(params[:id])
    task.update(completed: false)
  end
end