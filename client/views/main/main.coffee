##########################################
Template.masterLayout.events
	'click': (e,t) ->
		$this = $(e.target)

		checkItem = (item, search) ->
			return item.is(search) or item.parents(search).is(search)

		if checkItem($this, ".master-content")
			Session.set("display-notification-box", false)
			Session.set("display-user-box", false)

		if checkItem($this, ".main-menu")
			Session.set("display-notification-box", false)
			Session.set("display-user-box", false)

		if checkItem($this, ".main-user")
			unless checkItem($this, ".notification-svg") or checkItem($this, ".notification-box")
				Session.set("display-notification-box", false)
			unless checkItem($this, ".avatar-box") or checkItem($this, ".user-dropdown")
				Session.set("display-user-box", false)

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