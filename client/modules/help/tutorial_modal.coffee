Template.tutorialModal.onCreated () ->
	@state = new ReactiveVar(0)


Template.tutorialModal.helpers
	showGreetings: () ->
		t = Template.instance()
		currentState = t.state.get()

		if @first_time and (currentState is 0)
			return true
		else
			return false

	lastPage: () ->
		t = Template.instance()
		currentState = t.state.get()
		return true if currentState is 3

	currentPage: () ->
		t = Template.instance()
		currentState = t.state.get()

		if @first_time and (currentState is 0)
			return 'tutorial-initial'
		else
			if currentState is 0
				t.state.set(1)
			return "tutorial-page-#{currentState}"

	showBack: () ->
		t = Template.instance()
		currentState = t.state.get()

		if @first_time and (currentState is 0)
			return false
		else
			return false if currentState is 1
			return true


Template.tutorialModal.events
	'click .start-tutorial': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		t.state.set(1)

	'click .tutorial-back': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		currentState = t.state.get()

		newState = currentState - 1
		t.state.set(newState)

	'click .tutorial-next': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		currentState = t.state.get()

		newState = currentState + 1
		t.state.set(newState)

	'click .tutorial-end': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		Modal.hide('tutorialModal')
