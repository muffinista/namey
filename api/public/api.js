/** namey */
namey = {
  // jx -- http://www.openjs.com/scripts/jx/ -- V3.00.A
  jx:{getHTTPObject:function(){var A=false;if(typeof ActiveXObject!="undefined"){try{A=new ActiveXObject("Msxml2.XMLHTTP")}catch(C){try{A=new ActiveXObject("Microsoft.XMLHTTP")}catch(B){A=false}}}else{if(window.XMLHttpRequest){try{A=new XMLHttpRequest()}catch(C){A=false}}}return A},load:function(url,callback,format){var http=this.init();if(!http||!url){return }if(http.overrideMimeType){http.overrideMimeType("text/xml")}if(!format){var format="text"}format=format.toLowerCase();var now="uid="+new Date().getTime();url+=(url.indexOf("?")+1)?"&":"?";url+=now;http.open("GET",url,true);http.onreadystatechange=function(){if(http.readyState==4){if(http.status==200){var result="";if(http.responseText){result=http.responseText}if(format.charAt(0)=="j"){result=result.replace(/[\n\r]/g,"");result=eval("("+result+")")}if(callback){callback(result)}}else{if(error){error(http.status)}}}};http.send(null)},init:function(){return this.getHTTPObject()}},

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

	this.jx.load('/name.json?' + tmp_params.join("&"), function(d) {
	  var tmp = eval('(' + d + ')');
	  if ( typeof(callback) == "function" ) {
		callback(tmp);
	  }
	});
  }
}
