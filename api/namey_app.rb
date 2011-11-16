require 'sinatra'
require 'sinatra/sequel'
require 'namey'
require 'json'

class Hash
  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end
end


# Establish the database connection; or, omit this and use the DATABASE_URL
# environment variable as the connection string:
#set :database, 'mysql://username@hostname/database'


#
# migration for logging names
#
migration "create the generated_names table" do
  database.create_table :generated_names do
    primary_key :id
    String :name, :null => false
    timestamp   :created_at, :null => false
  end
end
  
get '/' do
  # use index.haml for readme
  erb :index #, :layout => :index
end
  
get '/name.?:format?' do
  @generator = Namey::Generator.new(database)

  opts = {
    :frequency => :common
  }.merge(params.symbolize_keys!)

  opts[:with_surname] = true if params[:with_surname] == "true"

  [:type, :frequency].each do |key|
    opts[key] = opts[key].to_sym if opts.has_key?(key)
  end

  opts.delete(:type) if ! [:male, :female, :surname].include?(opts[:type])
  
  count = (params.delete(:count) || 1).to_i
  count = 10 if count > 10
  
  names = 1.upto(count).collect do
    @generator.generate(opts)
  end.compact

  names.each do |name|
    database[:generated_names].insert(:name => name)
  end
  
  if params[:format] == "json"
    content_type :json, 'charset' => 'utf-8'
    tmp = JSON.generate names
    if params[:callback]
      "#{params[:callback]}(#{tmp});"
    else
      tmp
    end
  else
    ["<ul>", names.collect { |n| "<li>#{n}</li>" }.join(" "), "</ul>"].join("")
  end
end 
