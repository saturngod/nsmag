function checkemail() {
	var mail = document.getElementById("mce-EMAIL").value;
	if(mail == "") {
	  $('#notification_container').html('<span class="alert">Email is required</span>');
	  return false;
	}
	if(!validateEmail(mail)) {
	  $('#notification_container').html('<span class="alert">Invalid Email Address</span>');
	  return false;
	}
	return true;
}

function validateEmail(email) {
  var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
}


$(function () {
  var $form = $('#mc-embedded-subscribe-form');
 
  $('#mc-embedded-subscribe').on('click', function(event) {
    if(event) event.preventDefault();
    if(checkemail()) {
    	register($form);
    }
  });
});


function register($form) {
  $.ajax({
    type: $form.attr('method'),
    url: $form.attr('action'),
    data: $form.serialize(),
    cache       : false,
    dataType    : 'json',
    contentType: "application/json; charset=utf-8",
    error       : function(err) { $('#notification_container').html('<span class="alert">Could not connect to server. Please try again later.</span>'); },
    success     : function(data) {
      
      if (data.result != "success") {
        var message = data.msg.substring(4);
        $('#notification_container').html('<span class="alert">'+message+'</span>');
      } 
 
      else {
        var message = data.msg;
        $('#notification_container').html('<span class="success">'+message+'</span>');
      }
    }
  });
}