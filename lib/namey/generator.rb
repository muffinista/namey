module Namey
  class Generator

    def initialize(dbname = Namey.db_path)     
      @db = SQLite3::Database.open dbname
    end

    def male(frequency = :common, surname = true)
      generate(:type => :male, :frequency => frequency, :with_surname => surname)
    end

    def female(frequency = :common, surname = true)
      generate(:type => :female, :frequency => frequency, :with_surname => surname)      
    end

    def surname(frequency = :common)
      generate(:type => :surname, :frequency => frequency)
    end
    
    def generate(params = {})
      params = {
        :type => :female,
        :frequency => :common,
        :with_surname => true
      }.merge(params)


      if ! ( params[:min_freq] || params[:max_freq] )
        params[:min_freq], params[:max_freq] = frequency_values(params[:frequency])
      end
      puts params.inspect
      
      name = get_name(params[:type], params[:min_freq], params[:max_freq])
      if params[:type] != :surname && params[:with_surname] == true
        name = "#{name} #{get_name(:surname, params[:min_freq], params[:max_freq])}"
      end
      name
    end
    

    def frequency_values(f)
      low = case f
            when :common then 0
            when :rare then 40
            when :all then 0
            else 0
            end

      high = case f
            when :common then 20
            when :rare then 100
            when :all then 100
            else 100
            end

      [ low, high ]
    end
    
    protected
    def get_name(src, min_freq = 0, max_freq = 100)
      @db.get_first_row("SELECT name FROM #{src.to_s} WHERE freq > ? AND freq < ? ORDER BY RANDOM() LIMIT 1;",
                         min_freq, max_freq).first
    end
    

    
  end
end
