$(document).ready(function() {
  $("input[name=frequency]").change(function() {
	console.log("HI!");
	if ( $("input[name=frequency]:checked").val() == "custom" ) {
	  $("#min_freq,#max_freq").removeClass("disabled").removeAttr("disabled"); 
	}
	else {
	  $("#min_freq,#max_freq").addClass("disabled").attr("disabled", true); ;
	}

  });

  $('#name-params').submit(function() {

	var opts = {  
      count:  $("select[name=count]").val(),
      with_surname:  $("input[name=with_surname]:checked").val() === "true"
	};

    var frequency = $("input[name=frequency]:checked").val();
	if ( frequency == "custom" ) {
	  opts.min_freq = $("input[name=min_freq]").val();
	  opts.max_freq = $("input[name=max_freq]").val();
	}
	else {
	  opts.frequency = frequency;
	}


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
