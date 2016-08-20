##########################################
Template.statusMessage.helpers
	statusMessage: () ->
		msg = Session.get "statusMessage"
		if msg
			return msg
		return false

##########################################
Template.statusTimeMessage.helpers
	timeMessage: () ->
		msg = Session.get "statusTimeMessage"
		if msg
			return msg
		return false

##########################################