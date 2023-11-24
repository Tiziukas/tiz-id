$(document).ready(function(){
  // LUA listener
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      var type        = event.data.type;
      var userData    = event.data.array['user'][0];
      var licenseData = event.data.array['licenses'];
      var mugshot = event.data.mugshot;
      if ( type == 'fakeid' || type == null) {
        $('img').show();
        $('#name').css('color', '#282828');

        $('img').attr('src', mugshot);
        $('#sex').text(userData.gender);
        }

        $('#name').text(userData.newname);
        $('#dob').text(userData.dob);
        $('#height').text(userData.height);
        $('#signature').text(userData.newname);
        $('#licenses').append('<p>'+ userData.category +'</p>');

        if ( type == 'fakeid' ) {
          if ( licenseData != null ) {
          Object.keys(licenseData).forEach(function(key) {
            var type = licenseData[key].type;
            if ( type == 'fakeid' ) {
              type = 'fakeid';
            }
          });
        }
      $('#id-card').css('background', 'url(assets/images/license.png)');
      }
      $('#id-card').show();
    } else if (event.data.action == 'closea') {
      $('#name').text('');
      $('#dob').text('');
      $('#height').text('');
      $('#signature').text('');
      $('#sex').text('');
      $('#id-card').hide();
      $('#licenses').html('');
    }
  });
});
