require 'sinatra'
require 'namey'

class Hash
  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end
end


class NameyApp < Sinatra::Base
  before do
    @generator = Namey::Generator.new("mysql://root@localhost/namey")
  end
  
  get '/' do
    'Hello world!'
  end

  get '/name' do
    opts = {
      :frequency => :common
    }.merge(params.symbolize_keys!)
    "#{@generator.generate(opts)}"
  end 
end
