DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/todo_list.db")

# models will go here
class Task
  include DataMapper::Resource
  property :id, Serial
  property :description, Text
  property :completed, Boolean, default: false
  property :created_at, DateTime
end

class MeetupGroup
  include DataMapper::Resource
  property :id, Serial
  property :name, Text
end


DataMapper.finalize.auto_upgrade!

class TodoApp < Sinatra::Base
  set :erb, escape_html: true

  configure :development do
    register Sinatra::Reloader
  end

  # example route, access this with http://localhost:9292/example
  get '/meetup_groups' do
    api_result = RestClient.get 'http://api.meetup.com/groups.json/?&topic=ruby&order=members'
    jhash = JSON.parse(api_result)
    counter = jhash['results'].count
    output = ''
    jhash['results'].each do |j|
      name = j['name']
      city = j['city']
      focus = j['who']
      count = j['members']
      contact = j['organizer_name']
      link = j['link']
      country = j['country']
      output << "&lt;tr&gt;&lt;td&gt;#{name}&lt;/td&gt; &lt;td&gt;&lt;a href = '#{link}' target = _new&gt;#{city}&lt;/a&gt;&lt;/td&gt;&lt;td&gt;#{country.upcase}&lt;/td&gt;&lt;td&gt;#{focus}&lt;/td&gt; &lt;td&gt;#{count}&lt;/td&gt;&lt;td&gt;#{contact}&lt;/td&gt;&lt;/tr&gt;"
    end

    erb :meetup_table, :locals => {result: output, counter: counter}
  end

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