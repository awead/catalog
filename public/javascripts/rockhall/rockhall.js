// Rockhall Javascript

function showComponents( id, ref ) {

  $.when( c1(id)).done(function(c1_data) {
    $("#c01-section").html(c1_data);
  });

};

function c1( id ) {
  return $.ajax({
    url:     "/components?component_level=1&ead_id=" + id,
    success: function(c1_data){ }
  });
};
