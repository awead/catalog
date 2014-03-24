// renders different alerts in the #main-flashes section of the page

function flashInfo(message) {
  var html = '<div id="flash_message" class="alert alert-info">'+message+'<span class="close">&times;</span></div>'
  $('#flash_message').remove();
  $('#main-flashes').prepend(html)
}

function flashAlert(message) {
  var html = '<div id="flash_message" class="alert alert">'+message+'<span class="close">&times;</span></div>'
  $('#flash_message').remove();
  $('#main-flashes').prepend(html)
}

function flashError(message) {
  var html = '<div id="flash_message" class="alert alert-error">'+message+'<span class="close">&times;</span></div>'
  $('#flash_message').remove();
  $('#main-flashes').prepend(html)
}

$(document).on('click', '#flash_message', function(event) {
  $(this).remove();
});