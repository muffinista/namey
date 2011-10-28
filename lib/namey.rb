#require 'sqlite3'

module Namey
  def self.db_path
    @@db_path
  end
  def self.db_path=(x)
    @@db_path = x
  end
  
  @@db_path = "sqlite://#{File.join(File.dirname(__FILE__), "..", "data", "names.db")}"

  require 'namey/generator'
end

