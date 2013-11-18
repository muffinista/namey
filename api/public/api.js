/** namey */
namey = {

    /*
     * Lightweight JSONP fetcher
     * Copyright 2010 Erik Karlsson. All rights reserved.
     * BSD licensed
     */
    // Lightweight JSONP fetcher - www.nonobtrusive.com
    jsonP:(function(){var a=0,c,f,b,d=this;function e(j){var i=document.createElement("script"),h=false;i.src=j;i.async=true;i.onload=i.onreadystatechange=function(){if(!h&&(!this.readyState||this.readyState==="loaded"||this.readyState==="complete")){h=true;i.onload=i.onreadystatechange=null;if(i&&i.parentNode){i.parentNode.removeChild(i)}}};if(!c){c=document.getElementsByTagName("head")[0]}c.appendChild(i)}function g(h,j,k){f="?";j=j||{};for(b in j){if(j.hasOwnProperty(b)){f+=encodeURIComponent(b)+"="+encodeURIComponent(j[b])+"&"}}var i="json"+(++a);d[i]=function(l){k(l);try{delete d[i]}catch(m){}d[i]=null;};e(h+f+"callback="+i);return i}return{get:g}}()),

    /**
     * API for namey random name generator.  There's two basic ways to use it.  First, just call namey.get with a callback:
     *
     * namey.get(function(n) { console.log(n); }); => ["John Clark"]
     *
     * The call returns an array because there's an option to request more than one random name. For example:
     *
     * namey.get({ count: 3, callback: function(n) { console.log(n); }}); ; => ["John Cook", "Ruth Fisher", "Donna Collins"]
     *
     * Here's the full list of parameters:
     * 
     * count -- how many names you would like (default: 1)
     *
     * type -- what sort of name you want 'female', 'male', 'surname', or leave blank if you want both genders
     *
     * with_surname -- true/false, if you want surnames with the first
     * name. If false, you'll just get first names.  Default is true.
     *
     * frequency -- 'common', 'rare', 'all' -- default is 'common'. This
     * picks a subset of names from the database -- common names are
     * names that occur frequently, rare is names that occur rarely.
     * 
     * min_freq/max_freq  -- specific values to get back a really
     * specific subset of the names db. values should be between 0 and
     * 100. You probably don't need this, but here's an example:
     * namey.get({ count: 3, min_freq: 30, max_freq: 50, callback: function(n) { console.log(n); }});
     * => ["Crystal Zimmerman", "Joshua Rivas", "Tina Bryan"]
     *
     * callback -- a function to do something with the data.  The data
     * passed in will be an array of names -- use them wisely.
     * 
     */
    get : function(options) {
	      var callback;
	      var tmp_params = [];

	      if ( typeof(options) == "function" ) {
	          callback = options;
	      }
	      else if ( typeof(options) == "object" ) {
	          callback = options.callback;

            if ( typeof(options.host) === "undefined" ) {
                options.host = "namey.muffinlabs.com";
            }

	          if ( typeof(options.count) == "undefined" ) {
		            options.count = 1;
	          }
	          tmp_params.push("count=" + options.count);

	          if ( typeof(options.type) != "undefined" && options.type != "both" ) {
		            tmp_params.push("type=" + options.type);
	          };

	          if ( options.type != "surname" && typeof(options.with_surname) != "undefined" ) {
		            tmp_params.push("with_surname=" + options.with_surname);
	          }
	          if ( options.min_freq ) {
		            tmp_params.push("min_freq=" + options.min_freq);
		            tmp_params.push("max_freq=" + options.max_freq);
	          }
	          else if ( typeof(options.frequency) != "undefined" ) {
		            tmp_params.push("frequency=" + options.frequency);
	          }
	      }

	      this.jsonP.get('//' + options.host + '/name.json', tmp_params, function(d) {
	          if ( typeof(callback) == "function" ) {
		            callback(d);
	          }
	          else {
		            console.log(d);
	          }
	      });
    }
}
