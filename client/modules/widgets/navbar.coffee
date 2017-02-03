Template.navbar.events
	'click .nav-selector': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		@action?()