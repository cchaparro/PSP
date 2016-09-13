##########################################
Template.masterLayout.onCreated () ->
	Session.set "statusMessage", false


Template.masterLayout.helpers
	documentTitle: () ->
		if Session.get("route")
			route = sys.getSessionRoute(Session.get("route"))

		if Session.get("statusTimeMessage")
			document.title = "(Registrando) #{route}"
		else
			document.title = route
		return ""


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
			unless checkItem($this, ".avatar-box")
				Session.set("display-user-box", false)

	'click .close-status': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		$(e.target).closest('.status-message').animate { opacity: 0 }, 200, ->
			Session.set "statusMessage", false

##########################################
Template.statusMessage.helpers
	statusMessage: () ->
		msg = Session.get "statusMessage"
		if msg
			return msg
		return false

Template.statusMessage.events
	'click .close-status': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		$(e.target).closest('.status-message').animate { opacity: 0 }, 200, ->
			Session.set "statusMessage", false

##########################################
Template.statusTimeMessage.helpers
	timeMessage: () ->
		msg = Session.get "statusTimeMessage"
		if msg
			return msg
		return false

##########################################