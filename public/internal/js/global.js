// AJAX
  var api_root = "/api/";

  function api_post(uri, data, callback) {
      $.ajax({ 
          url: api_root + uri, 
          data: data,
          dataType: "json", 
          type: "POST", 
          success: callback,
          error: function(request, status, error) {
              console.log("Error status " + status);
              console.log("Error request status text: " + request.statusText);
              console.log("Error request status: " + request.status);
              console.log("Error request response text: " + request.responseText);
              console.log("Error response header: " + request.getAllResponseHeaders());
              $("#error").html(status);
          }
      });
  }

  function api_get(uri, data, callback) {
      $.ajax({ 
          url: api_root + uri, 
          data: data,
          dataType: "json", 
          type: "GET", 
          success: callback,
          error: function(request, status, error) {
              console.log("Error status " + status);
              console.log("Error request status text: " + request.statusText);
              console.log("Error request status: " + request.status);
              console.log("Error request response text: " + request.responseText);
              console.log("Error response header: " + request.getAllResponseHeaders());
              $("#error").html(status);
          }
      });
  }


  $(document).ajaxSend(function(r, s) {
      popLoadScreen($("#loadframe"));

  });

  $(document).ajaxComplete(function() {
      removeLoadScreen($("#loadframe"));
  });

  popLoadScreen = function(o) {

      $(o).empty();
      $(o).append("<div style='position: absolute; top: 50%; left: 50%; margin-top: -50px; margin-left: -50px; z-index: 5000'><img src='/internal/images/ajax-loader.gif'></div>").hide().fadeIn(200);
  }

  removeLoadScreen = function(o) {
      $(o).fadeOut(function(){
          $(this).empty();f
      });
  }

// Cookies:
  function getCookie(c_name) {
    var i,x,y,ARRcookies=document.cookie.split(";");
    for (i=0;i<ARRcookies.length;i++)
      {
      x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
      y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
      x=x.replace(/^\s+|\s+$/g,"");
      if (x==c_name)
        {
        return unescape(y);
        }
      }
  }

  function setCookie(c_name,value,exdays) {
    var exdate=new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
    document.cookie=c_name + "=" + c_value;
  }
//

// popups
function displayPopup(id) {
    $("#" + id).each(function() {
        $("#mask").fadeIn("fast");
        var p = $(this);
        p.css({
            left: ($(window).width() - p.outerWidth()) / 2,
            top: ($(window).height() - p.outerHeight()) / 2
        });
        p.fadeIn("fast");
    });
}

function hidePopup(id) {
    $("#" + id).fadeOut("fast");
    $("#mask").fadeOut("fast");
}
