// Rockhall Javascript

function showWaiting(ref) {

  $("#" + ref + "-switch").remove();
  $("#" + ref).append("<div id=\"" + ref + "-switch\"><img alt='Loading...' src='/images/icons/waiting.gif' /></div>");

}
