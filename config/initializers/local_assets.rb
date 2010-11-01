ApplicationController.before_filter do |controller|

  # add in local css
  controller.stylesheet_links    << "application.css"


  # add in local javascript
  local_js = [ 
    [ "InfusionAll.js" ],
    [ "simple.js" ],
    [ "jquery.notice.js" ],
    [ "application.js" ],
    [ "infusion/framework/core/js/ProgressiveEnhancement.js"],
    [ "loupe/loupe.js"],
  ]

  #controller.javascript_includes << local_js

end 
