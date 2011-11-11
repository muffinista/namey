$(document).ready(function() {
  $("input[name=frequency]").change(function() {
	if ( $("input[name=frequency]:checked").val() == "custom" ) {
	  $(".custom_range_wrapper").fadeIn();
	  $("#min_freq,#max_freq").removeClass("disabled").removeAttr("disabled"); 
	}
	else {
	  $(".custom_range_wrapper").fadeOut();
	  $("#min_freq,#max_freq").addClass("disabled").attr("disabled", true); ;
	}
  });

  $("input[name=type]").change(function() {
	if ( $("input[name=type]:checked").val() != "surname" ) {
	  $(".surname-wrapper").fadeIn();
	}
	else {
	  $(".surname-wrapper").fadeOut();
	}
  });



  $('#name-params').submit(function() {

	$(".spinny").show();

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
	  $(".spinny").hide();
	  $("#nameList").val(r.join("\n"));
	}
	namey.get(opts);

	return false;
  });
});
