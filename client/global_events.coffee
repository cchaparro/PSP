##################################################
Template.body.events
	'click': (e,t) ->
		$this = $(e.target)

		checkItem = (item, search) ->
			return item.is(search) or item.parents(search).is(search)

		if checkItem($this, ".master-content")
			Session.set("display-notification-box", false)

		if checkItem($this, ".main-menu")
			Session.set("display-notification-box", false)

		if checkItem($this, ".main-user")
			unless checkItem($this, ".notification-svg")
				Session.set("display-notification-box", false)

##################################################