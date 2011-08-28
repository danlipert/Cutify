$(document).ready(function(){	


    $('#portfolio').cycle({
		fx: 'scrollHorz', // choose your transition type, ex: fade, scrollUp, shuffle, etc...
        delay: 0, 
        prev:'.left-arrow',
        next:'.right-arrow',
        speed: 1000,
        timeout: 14000,

	});
    
 

   setTimeout(function(){
  $("#alert").slideUp("slow", function () {
  $("#alert").remove();
      });

}, 2000);



    $('input[type=text], textarea').each(function() {
    
           var default_value = this.value;
           $(this).focus(function(){
                   if(this.value == default_value) {
                           this.value = '';
                           $(this).addClass('activeText');
                   }
           });
           $(this).blur(function(){
                   if(this.value == '') {
                           this.value = default_value;
                           $(this).removeClass('activeText');
                   }
           });
    });
    
    
	getTwitters('tweet', { 
	  id: 'tmoapps', 
	  count: 1, 
	  enableLinks: true, 
	  ignoreReplies: false, 
	  clearContents: true,
	  template: '"%text%" <a href="http://twitter.com/%user_screen_name%/statuses/%id_str%/">%time%</a>'
	});

});

