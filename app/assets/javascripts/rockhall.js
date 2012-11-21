// rockhall.js
//
// Place to keep our local javascript code 


$(document).ready(function() {

  setAllBookmarksCheckbox();

  $("input#toggle_all_bookmarks").click(function(action) {

    if ($(this).is(':checked')) {
      // Select all bookmarks or any that are not already selected
      $("input.toggle_bookmark").each(function() {
        if (!$(this).is(':checked')) {
          this.click();
        }
      });
      $("label#toggle_all_bookmarks").text("Remove all");
    }
    else {
      // De-select any checked bookmarks
      $("input.toggle_bookmark").each(function() {
        if ($(this).is(':checked')) {
          this.click();
        }
      });
      $("label#toggle_all_bookmarks").text("Select all");
    }
  });

});

$(document).ready(returnStatus);
$(document).ready(returnHoldings);


function returnStatus() {
  $('.innovative_status').each(function() {

    var id  = $(this).attr("id");
    var url = ROOT_PATH + "holdings/" + id;

    $.ajax({
      url: url,
      error: function(){
        $('#'+id).append("Unknown");
      },
      success: function(data){
        $('#'+id).replaceWith(data);
      }
    });

  });
}

function returnHoldings() {
  $('.innovative_holdings').each(function() {

    var id  = $(this).attr("id");
    var url = ROOT_PATH + "holdings/" + id + "?type=full";

    $.ajax({
      url: url,
      error: function(){
        $('.innovative_holdings').append("Unknown");
      },
      success: function(data){
        $('.innovative_holdings').append(data);
      }
    });

  });

}

function setAllBookmarksCheckbox() {
  // Are all the bookmarks selected?
  var all_bookmarks_checked = true;
  $("input.toggle_bookmark").each(function() {
    if (!$(this).is(':checked')) {
      all_bookmarks_checked = false;
    }      
  });
  // If they are, check the checkbox and change the text
  if (all_bookmarks_checked) {
    $("input#toggle_all_bookmarks").prop("checked", true);
    $("label#toggle_all_bookmarks").text("Remove all");
  } 
  else {
    $("input#toggle_all_bookmarks").prop("checked", false);
    $("label#toggle_all_bookmarks").text("Select all");
  }
}
