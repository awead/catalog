// rockhall.js
//
// A place to keep our local javascript code 

// Call our named functions first
$(document).ready(returnStatus);
$(document).ready(returnHoldings);

$(document).on('click', '#show_more_components', function(event) {
  addMoreComponents(event)
});

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

  // Javascript to enable link to tab
  var url = document.location.toString();
  if (url.match('#')) {
    $('.nav-tabs a[href=#'+url.split('#')[1]+']').tab('show') ;
  } 

  // Change hash for page-reload
  $('.nav-tabs a').on('shown', function (e) {
      // set this to empty so it doesn't jump to the anchor
      window.location.hash = "";
  })

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
        if (data === 'Copies Available') {
          $('#'+id).toggleClass('label-success');
        }
        else {
          $('#'+id).toggleClass('label-warning');
        }
        $('#'+id).text(data);
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

function addMoreComponents(event) {

  var start = $('#inventory_table tr').last().data('row') + 1;
  var ead = $('#inventory_table').data('ead');
  var ref = $('#inventory_table').data('ref');
  var url;

  if ( ref === undefined || ref === null )  {
    url = ROOT_PATH+'components/'+ead+'?start='+start;
  }
  else {
    url = ROOT_PATH+'components/'+ead+'/'+ref+'?start='+start;
  }

  var jqxhr = $.get(url)
      .done(function(data) {
        if (data != '') {
          $('table#inventory_table tbody').append(data);
          if ( $('#inventory_table tr').last().data('row') + 1 === $('#inventory_table').data('numfound') )
            $('#show_more_components').toggleClass('hidden');
        }
      })
      .fail(function(jqXHR, textStatus, errorThrown) {
        var msg = '<tr class="alert alert-error"><td colspan="2">Error retrieving additionl components: '+errorThrown+'</td></tr>'
        $('#inventory_table').append(msg);
      });

  event.preventDefault();
}