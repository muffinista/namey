#require 'sqlite3'

module Namey
  def self.db_path
    @@db_path
  end
  def self.db_path=(x)
    @@db_path = x
  end
  
  # Return a directory with the project libraries.
  def self.libdir
    t = ["#{File.dirname(File.expand_path($0))}/../lib/#{Namey::NAME}",
      "#{Gem.dir}/gems/#{Namey::NAME}-#{Namey::VERSION}/lib/#{Namey::NAME}"]

    puts t.inspect

    t.each {|i| return i if File.readable?(i) }
    raise "both paths are invalid: #{t}"
  end

  @@db_path = "sqlite://#{File.join(self.libdir, "..", "..", "data", "names.db")}"  

  require 'namey/generator'
end

