$(document).ready(function() {
  $('#name-params').submit(function() {

	var opts = {  
      frequency:  $("input[name=frequency]:checked").val(),
      count:  $("select[name=count]").val(),
      with_surname:  $("input[name=with_surname]:checked").val() === "true"
	};

	var type =  $("input[name=type]:checked").val();
	if ( type != "both" ) {
	  opts.type = type;
	}

	opts.callback = function(r) {
		$("#nameList").val(r);
	  }
	namey.get(opts);

	return false;
  });
});
