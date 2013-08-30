module Namey
  def self.db_path
    @@db_path ||= "#{'jdbc:' if RUBY_PLATFORM == 'java'}sqlite://" + File.join(self.libdir, "..", "data", "names.db")
  end
  def self.db_path=(x)
    @@db_path = x
  end


  require 'namey/version'
  
  # Return a directory with the project libraries.
  def self.libdir
    t = ["#{File.expand_path(File.dirname(__FILE__))}", "#{Gem.dir}/gems/#{Namey::NAME}-#{Namey::VERSION}"]

    t.each {|i| return i if File.readable?(i) }
    raise "both paths are invalid: #{t}"
  end


  
  require 'namey/generator'
end

