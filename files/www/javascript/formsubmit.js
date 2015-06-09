$(function() {   
	$("#myform .submit").click(function() {     

		var name = $("#form_name").val();     

		var email = $("#form_email").val();     

		var text = $("#msg_text").val();     

		var dataString = 'name='+ name + '&email=' + email + '&text=' + text;      


		$.ajax({    

		type: "POST",    

		url: "contact.php", 

		data: dataString,  

		success: function(){       

			$('#responsemessage').fadeIn(1000);     
		}    
		});     

	$("#myform")[0].reset();

		return false;   


	}); 

});