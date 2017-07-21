require 'sequel'

module Namey

  #
  # Main class for namey, handles generating a name.
  #
  class Generator

    #
    # initialize the name generator
    # * +dbname+ - Sequel style db URI ex: 'sqlite://foo.db'
    def initialize(dbname = nil)
      if dbname.is_a? Sequel::Database
        @db = dbname
      else
        dbname = Namey.db_path if dbname.nil?
        @db = Sequel.connect(dbname)
      end
    end

    #
    # generate a name
    #
    # * +frequency+ - :common, :rare, :all
    # * +surname+ - true if you want a full name, false if you just want a first name
    def name(frequency = :common, surname = true)
      generate(:frequency => frequency, :with_surname =>surname)
    end
    
    #
    # generate a male name
    #
    # * +frequency+ - :common, :rare, :all
    # * +surname+ - true if you want a full name, false if you just want a first name
    def male(frequency = :common, surname = true)
      generate(:type => :male, :frequency => frequency, :with_surname => surname)
    end

    #
    # generate a female name
    #
    # * +frequency+ - :common, :rare, :all
    # * +surname+ - true if you want a full name, false if you just want a first name
    def female(frequency = :common, surname = true)
      generate(:type => :female, :frequency => frequency, :with_surname => surname)      
    end

    #
    # generate a surname
    #
    # * +frequency+ - :common, :rare, :all
    def surname(frequency = :common)
      generate(:type => :surname, :frequency => frequency)
    end
    
    #
    # generate a name using the supplied parameter hash
    #
    # * +params+ - A hash of parameters
    #
    # ==== Params
    # * +:type+ - :male, :female, :surname
    # * +:frequency+ -  :common, :rare, :all
    # * +:min_freq+ - raw frequency values to specify a precise range
    # * +:max_freq+ - raw frequency values to specify a precise range
    def generate(params = {})
      params = {
        :type => random_gender,
        :frequency => :common,
        :with_surname => true
      }.merge(params)

      
      if ! ( params[:min_freq] || params[:max_freq] )
        params[:min_freq], params[:max_freq] = frequency_values(params[:frequency])
      else

        #
        # do some basic data validation in case someone is being a knucklehead
        #
        params[:min_freq] = params[:min_freq].to_i
        params[:max_freq] = params[:max_freq].to_i

        params[:max_freq] = params[:min_freq] + 1 if params[:max_freq] <= params[:min_freq]

        # max_freq needs to be at least 4 to get any results back,
        # because the most common male name only rates 3.3
        # JAMES          3.318  3.318      1
        params[:max_freq] = 4 if params[:max_freq] < 4
      end

      
      name = get_name(params[:type], params[:min_freq], params[:max_freq])

      # add surname if needed
      if params[:type] != :surname && params[:with_surname] == true
        name = "#{name} #{get_name(:surname, params[:min_freq], params[:max_freq])}"
      end
      name
    end
    

    protected

    #
    # generate a set of min/max frequency values for the specified
    # frequency symbol
    #
    # * +f+ -  desired frequency range -- :common, :rare, :all
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
    


    #
    # pick a gender at random
    #
    def random_gender
      rand > 0.5 ? :male : :female
    end
    
    #
    # randomly sort a result set according to the data adapter class
    #
    def random_sort(set)

      set.order do
        # this is a bit of a hack obviously, but it checks the sort of
        # data engine being used to figure out how to randomly sort
        if @db.class.name !~ /mysql/i
          random.function
        else
          rand.function
        end
      end
    end

    #
    # query the db for a name
    #
    def get_name(src, min_freq = 0, max_freq = 100)     
      tmp = random_sort(@db[src.to_sym].filter{(freq >= min_freq) & (freq <= max_freq)})
      tmp.count > 0 ? tmp.first[:name] : nil
    end
  end
end
