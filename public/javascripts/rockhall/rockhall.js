// Rockhall Javascript
// this is just a place-holder for now


$(document).ready(returnStatus);


function returnStatus() {


  $('.innovative_status').each(function() {

    var id  = $(this).attr("id");
    var url = "/holdings/" + id;

    $.ajax({
      url: url,
      error: function(){
        $('#'+id).append("Unknown");
      },
      success: function(data){
        $('#'+id).append(data);
      }
    });


  });


}