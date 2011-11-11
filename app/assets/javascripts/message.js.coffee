# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
	console.log "ready!"
	$(".grid").masonry({isAnimated: !Modernizr.csstransitions, gutterWidth: 1,isFitWidth:true})
	$(".youtube").click ->
		vid =  $(this).attr("rel")
		$(this).addClass("selected")
		$.getJSON "http://gdata.youtube.com/feeds/api/videos/"+ vid + "?v=2&alt=json",  (json) ->
			swfobject.embedSWF("http://www.youtube.com/v/" + vid+ "?version=3&f=user_uploads&app=youtube_gdata" + '&rel=1&border=0&fs=1&autoplay=1' , 'player', '640', '390', '9.0.0', false, false, {allowfullscreen: 'true'})
			$("#info").text(JSON.stringify(json))
			$('html,body').animate({scrollTop:0},1000)
	
	$(".tumblr").click ->
		vid =  $(this).attr("rel")
		obj = vimeos[vid]
		$('<iframe src="http://player.vimeo.com/video/'+vid+'?title=0&amp;byline=0&amp;portrait=0"' +
		 'width="'+ obj["width"] + '" height="' + obj["width"] +  '" frameborder="0" webkitAllowFullScreen allowFullScreen></iframe>').appendTo("#playerContainer")
		$('html,body').animate({scrollTop:0},1000)