Template.statusMessage.helpers
	statusMessage: () ->
		msg = Session.get "statusMessage"
		if msg
			return msg
		return false

	messageIcon: () ->
		message = @css
		return 'check' if message is 'success'
		return 'warning' if message is 'warning'
		return 'clear'


Template.statusMessage.events
	'click .close-status': (e,t) ->
		e.stopPropagation()
		e.preventDefault()

		$(e.target).closest('.status-message').animate { opacity: 0 }, 200, ->
			Session.set "statusMessage", false


Template.statusTimeMessage.helpers
	timeMessage: () ->
		msg = Session.get "statusTimeMessage"
		if msg
			return msg
		return false
