// rockhall.js
//
// A place to keep our local javascript code 

// Call our named functions first
$(document).ready(returnStatus);
$(document).ready(returnHoldings);
$(document).ready(nextComponent);
$(document).ready(closeComponent);

//
// Anonymous fuctions
//

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

// Highlihght and scroll to any archival items
$(document).ready(function() {

  var parameters = window.location.href.split("/");
  var ref = parameters[parameters.length-1];

  if (ref.match(/ref/)) {
    $("#"+ref).css("background-color", "yellow");
    $("html, body").animate({ scrollTop: $("#"+ref).offset().top }, 1000);
  }
  

});

//
// Named functions
//

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

function nextComponent() {
  $('.next_component_button').live("click", function(action) {

    var waiting = $(this).attr("id")+"-waiting";
    var parent  = $(this).parent("div").attr("id");
    $(this).toggleClass("hidden");
    $("#"+waiting).toggleClass("hidden");
    $.get(this, function(data) {
      $("#"+parent).slideDown("normal", function() { $(this).append(data); } );
      $("#"+waiting).toggleClass("hidden");
    });
    action.preventDefault();

  });  
}

function closeComponent() {
  $('.close_component_button').live("click", function(action) {
    
    var parent  = $(this).parent("div").attr("id");
    var open    = $(this).attr("id").replace("close","open");
    $("#"+parent+"-list").slideUp("normal", function() { $(this).remove(); } );
    $("#"+open).toggleClass("hidden");
    $(this).remove();

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