require 'sinatra'
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

before do
  @generator = Namey::Generator.new("mysql://root@localhost/namey")
end
  
get '/' do
  # use index.haml for readme
  erb :index #, :layout => :index
end
  
get '/name.?:format?' do
  opts = {
    :frequency => :common
  }.merge(params.symbolize_keys!)

  opts[:with_surname] = true if params[:with_surname] == "true"

  [:type, :frequency].each do |key|
    opts[key] = opts[key].to_sym if opts.has_key?(key)
  end

  opts.delete(:type) if ! [:male, :female, :surname].include?(opts[:type])
  #opts[:type] = "both" if ! [:male, :female, :surname].include?(opts[:type])
  
  count = (params.delete(:count) || 1).to_i
  count = 10 if count > 10
  
  names = 1.upto(count).collect do
    @generator.generate(opts)
  end
  
  if params[:format] == "json"
    content_type :json, 'charset' => 'utf-8'
    JSON.pretty_generate names
  else
    ["<ul>", names.collect { |n| "<li>#{n}</li>" }.join(" "), "</ul>"].join("")
  end
end 
