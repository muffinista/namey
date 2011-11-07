namey = {
  // jx -- http://www.openjs.com/scripts/jx/ -- V3.00.A
  jx:{getHTTPObject:function(){var A=false;if(typeof ActiveXObject!="undefined"){try{A=new ActiveXObject("Msxml2.XMLHTTP")}catch(C){try{A=new ActiveXObject("Microsoft.XMLHTTP")}catch(B){A=false}}}else{if(window.XMLHttpRequest){try{A=new XMLHttpRequest()}catch(C){A=false}}}return A},load:function(url,callback,format){var http=this.init();if(!http||!url){return }if(http.overrideMimeType){http.overrideMimeType("text/xml")}if(!format){var format="text"}format=format.toLowerCase();var now="uid="+new Date().getTime();url+=(url.indexOf("?")+1)?"&":"?";url+=now;http.open("GET",url,true);http.onreadystatechange=function(){if(http.readyState==4){if(http.status==200){var result="";if(http.responseText){result=http.responseText}if(format.charAt(0)=="j"){result=result.replace(/[\n\r]/g,"");result=eval("("+result+")")}if(callback){callback(result)}}else{if(error){error(http.status)}}}};http.send(null)},init:function(){return this.getHTTPObject()}},
  get : function(options) {
	var callback, type, frequency, with_surname, min_freq, max_freq;
	var params = "";

	if ( typeof(options) == "function" ) {
	  callback = options;
	}
	else if ( typeof(options) == "object" ) {
	  callback = options.callback;

	  var tmp_params = [];
	  if ( options.type != "both" ) {
		tmp_params.push("type=" + options.type);
	  };

	  if ( options.type != "surname" ) {
		tmp_params.push("with_surname=" + options.with_surname);
	  }
	  if ( options.min_freq ) {
		tmp_params.push("min_freq=" + options.min_freq);
		tmp_params.push("max_freq=" + options.max_freq);
	  }
	  else {
		tmp_params.push("frequency=" + options.frequency);
	  }

	  params = tmp_params.join("&");
	}

	console.log(params);

	this.jx.load('/name.json?' + params, function(d) {
	  var tmp = eval('(' + d + ')');
	  console.log(tmp);
	  if ( typeof(callback) == "function" ) {
		callback(tmp);
	  }
	});
  }
}
