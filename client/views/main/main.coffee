##########################################
Template.masterLayout.events
	'click': (e,t) ->
		$this = $(e.target)
		console.log "Di click aqui"

		checkItem = (item, search) ->
			return item.is(search) or item.parents(search).is(search)

		if checkItem($this, ".master-content")
			Session.set("display-notification-box", false)

		if checkItem($this, ".main-menu")
			Session.set("display-notification-box", false)

		if checkItem($this, ".main-user")
			unless checkItem($this, ".notification-svg")
				Session.set("display-notification-box", false)

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