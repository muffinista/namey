Namey
=====

Namey is a ruby gem for auto-generating names.  It uses the [US Census
Bureau database](http://www.census.gov/genealogy/names/) of first and last names to generate random
names. Since the database itself specifies the frequency of each name,
you can get specify whether you want a common name, rare name, etc.


## Usage ##

Using namey is pretty straightforward. 

    require 'namey'
    @generator = Namey::Generator.new

    @generator.name
     => "Maria Fisher" 

Or, to get a particular frequency level, try one of these:

    @generator.name(:common)
     => "Michael Thomas" 
    @generator.name(:rare)
	 => "Deangelo Jotblad" 

	@generator.name(:all)
     => "Emanuel Boddorf" 

You can also specify `male` or `female` to stick to one gender:

    @generator.male
     => "David Gonzales" 
    @generator.female
     => "Sharon Richardson" 

	@generator.male(:rare)
	=> "Son Plude" 

	@generator.female(:rare)
	=> "Blossom VanWie" 

NOTE: All these methods default to returning common names unless you
specify a different level.

Finally, you can specify true/false as the second parameter to any
call to specify if you want a surname:

    @generator.male(:common, false)
     => "Michael" 
    @generator.male(:common, false)
     => "William" 

Finally, you can access the `generate` method directly and specify `min_freq`
and `max_freq` to get a range of names:

	# a somewhat rare name
    @generator.generate(:type => :male, :with_surname => true, :min_freq => 80, :max_freq => 100)
     => "Salvatore Billard" 

	# a more rare name
	@generator.generate(:type => :male, :with_surname => true, :min_freq => 90, :max_freq => 100)
	=> "Broderick Burhanuddin" 

	# a common name
	@generator.generate(:type => :male, :with_surname => true, :min_freq => 0, :max_freq => 5)
	=> "James Davis" 
	
	# another common name
	@generator.generate(:type => :female, :with_surname => true, :min_freq => 0, :max_freq => 5)
	=> "Linda Williams"

## Data ##

The data for namey is in a SQLite database, which is included with the
gem.  If you want to fiddle around, you can check out Namey::Importer,
or the `namey-load-data` script included with the gem, which will
generate the database from the original source files.

@todo -- options for other db engines

## Capitalization ##

The data from the Census Bureau is in all caps, it looks a lot like
this:

	SMITH          1.006  1.006      1
	JOHNSON        0.810  1.816      2
	WILLIAMS       0.699  2.515      3
	JONES          0.621  3.136      4
	BROWN          0.621  3.757      5

That's fine with basic names, but names with more than one capital in
them are challenging.  The data is also stripped of apostrophes, so
O'Brien is actually OBRIEN. The namey parser attempts to correct some
of this, but it probably misses some.  If you find any glaring
examples, just let me know.

