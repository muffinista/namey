module Namey
  class Parser

    attr_accessor :db

    def initialize(dbname)
      # Open a database
      @db = SQLite3::Database.new dbname
    end

    def load_male_names(src)
      parse_file(src, "male")
    end

    def load_female_names(src)
      parse_file(src, "female")
    end

    def load_surnames(src)
      parse_file(src, "surname")
    end

    protected
    def parse_file(src, dest)
      create_table(dest)

      file = File.new(src, "r")
      while (line = file.gets)
        data = line.split

        name = data.first.capitalize
        freq = data[2].to_f

        if dest == "surname"
          name = cleanup_surname(name)
        end
        
        puts "#{name} #{freq}"
        @db.execute "insert into #{dest} (name, freq) values ( ?, ? )", name, freq
      end
      file.close     
    end

    def create_table(name)   
      # Create a database
      @db.execute "drop table IF EXISTS #{name};"
      @db.execute "create table #{name} (name varchar(20), freq REAL);"
    end

    def cleanup_surname(name)
      if name.length > 4
        name.gsub!(/^Mc(\w+)/) { |s| "Mc#{$1.capitalize}" }
        name.gsub!(/^Mac(\w+)/) { |s| "Mac#{$1.capitalize}" }
        name.gsub!(/^Mac(\w+)/) { |s| "Mac#{$1.capitalize}" }
        name.gsub!(/^Osh(\w+)/) { |s| "O'sh#{$1}" }
        name.gsub!(/^Van(\w+)/) { |s| "Van#{$1.capitalize}" }
        name.gsub!(/^Von(\w+)/) { |s| "Von#{$1.capitalize}" }        
        name.gsub!(/^De(\w+)/) { |s| "De#{$1.capitalize}" }        
      end
      name
    end
  end
end
