module Namey
  class Generator

    def initialize(dbname = Namey.db_path)     
      @db = SQLite3::Database.open dbname
    end

    def male
      "#{get_name('male')} #{get_name('surname')}"
    end

    def female
      "#{get_name('female')} #{get_name('surname')}"
    end

    protected
    def get_name(src)
      @db.get_first_row("SELECT name FROM #{src} ORDER BY RANDOM() LIMIT 1;").first
    end
    

    
  end
end
