$(document).ready(function() {
  $('#name-params').submit(function() {

	var opts = {  
	  type: $("input[name=type]:checked").val(),
      frequency:  $("input[name=frequency]:checked").val(),
      count:  $("select[name=count]").val(),
      with_surname:  $("input[name=with_surname]:checked").val()
	};

	$.ajax({
	  type: 'GET',
	  url: '/name.json',
	  data: opts,
	  success: function(r) {
		$("#nameList").val(r);
	  },
	  dataType: 'json'
	});

	return false;
  });
});
