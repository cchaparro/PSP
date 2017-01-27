Template.createQuestionModal.onCreated () ->
	@category = new ReactiveVar("general")
	@errorStateTitle = new ReactiveVar(false)
	@errorStateDescription = new ReactiveVar(false)


Template.createQuestionModal.helpers
	questionCategory: () ->
		t = Template.instance()
		switch t.category.get()
			when "general"
				return "General"
			when "interface"
				return "Interfaz"
			when "psp"
				return "Metodologia PSP"

	errorStateTitle: () ->
		t = Template.instance()
		return t.errorStateTitle.get()

	errorStateDescription: () ->
		t = Template.instance()
		return t.errorStateDescription.get()


Template.createQuestionModal.events
	'click .question-category-option': (e,t) ->
		e.preventDefault()
		value = $(e.target).data('value')
		t.category.set(value)

	'keypress .question-title': (e,t) ->
		title = $(e.target).val()
		if title
			t.errorStateTitle.set(false)

	'keypress .question-description': (e,t) ->
		description = $(e.target).val()
		if description
			t.errorStateDescription.set(false)

	'click .question-create': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		title = t.$('.question-title').val()
		description = t.$('.question-description').val()
		questionCategory = t.category.get()

		data = {
			title: title
			description: description
			category: questionCategory
			parentId: null
			amountAnswers: 0
			completed: false
		}

		if !title or !description
			if !title
				t.errorStateTitle.set(true)
			if !description
				t.errorStateDescription.set(true)
		else
			Meteor.call "create_question", data, (error)->
				if error
					console.warn(error)
					sys.flashStatus("create-question-error")
				else
					sys.flashStatus("create-question-successful")
					Modal.hide('createQuestionModal')
