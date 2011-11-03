require 'sequel'

module Namey

  #
  # parse the census bureau data files and load into our datasource
  #
  class Parser

    attr_accessor :db

    #
    # initialize the parser
    # dbname - Sequel style db URI ex: 'sqlite://foo.db'
    #   
    def initialize(dbname = Namey.db_path)     
      @db = Sequel.connect(dbname)
    end

    #
    # load in the male name list
    #
    def load_male_names(src)
      parse_file(src, "male")
    end

    #
    # load in the female name list
    #
    def load_female_names(src)
      parse_file(src, "female")
    end

    #
    # load in the surname list
    #   
    def load_surnames(src)
      parse_file(src, "surname")
    end

    protected

    #
    # parse a census file.  it will have the format:
    #    name           freq   cumulative rank
    #    MARY           2.629  2.629      1
    #    PATRICIA       1.073  3.702      2
    #    LINDA          1.035  4.736      3
    #
    # we only need the name and the frequency, parse those out and
    # insert into specified table
    #
    # src - which file to parse
    # dest - which table to load into
    def parse_file(src, dest)
      create_table(dest)

      puts "***** Importing #{dest}"

      count = 0
      names = File.foreach(src).collect do |line|
        count += 1
        if count % 2000 == 0
          puts count
        end

        data = line.split

        name = data.first.capitalize
        freq = data[2].to_f

        name = if dest == "surname"
                 cleanup_surname(name)
               else
                 cleanup_firstname(name)
               end

        {:name => name, :freq => freq}
      end

      puts "loading into db"

      # remove any existing records
      @db[dest.to_sym].truncate

      # insert!
      @db[dest.to_sym].multi_insert(names)
    end

    #
    # create a name table
    #
    def create_table(name)   
      if ! db.tables.include?(name)
        db.create_table name do
          String :name, :size => 15
          Float :freq
          index :freq
        end
      end
    end

    #
    # apply some simple regexps to clean up first names
    #
    def cleanup_firstname(name)
      name.gsub(/^Dean(\w+)/) { |s| "DeAn#{$1}" }
    end

    #
    # apply some simple regexps to clean up surnames
    #
    def cleanup_surname(name)
      if name.length > 4
        name.gsub!(/^Mc(\w+)/) { |s| "Mc#{$1.capitalize}" }
        name.gsub!(/^Mac(\w+)/) { |s| "Mac#{$1.capitalize}" }
        name.gsub!(/^Mac(\w+)/) { |s| "Mac#{$1.capitalize}" }
        name.gsub!(/^Osh(\w+)/) { |s| "O'sh#{$1}" }
        name.gsub!(/^Van(\w+)/) { |s| "Van#{$1.capitalize}" }
        name.gsub!(/^Von(\w+)/) { |s| "Von#{$1.capitalize}" }        
#        name.gsub!(/^Dev(\w+)/) { |s| "DeV#{$1}" }        
      end
      name
    end
  end
end
