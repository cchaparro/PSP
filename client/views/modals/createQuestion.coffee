#######################################
Template.createQuestion.onCreated () ->
	@category = new ReactiveVar("general")
	#State 0(Default), State 1(Missing Field)
	@errorStateTitle = new ReactiveVar(0)
	@errorStateDescription = new ReactiveVar(0)

Template.createQuestion.helpers
	questionCategory: () ->
		switch Template.instance().category.get()
			when "general"
				return "General"
			when "interface"
				return "Interfaz"
			when "psp"
				return "Metodologia PSP"

	errorStateTitle: () ->
		return Template.instance().errorStateTitle.get()

	errorStateDescription: () ->
		return Template.instance().errorStateDescription.get()


Template.createQuestion.events
	'click .question-category-option': (e,t) ->
		value = $(e.target).data('value')
		t.category.set(value)

	'keypress .question-title': (e,t) ->
		title = $(e.target).val()
		if title!=''
			t.errorStateTitle.set(0)

	'keypress .question-description': (e,t) ->
		description = $(e.target).val()
		if description!=''
			t.errorStateDescription.set(0)

	'click .pry-modal-create': (e,t) ->
		title = $('.question-title').val()
		description = $('.question-description').val()
		questionCategory = t.category.get()

		data = {
			title: title
			description: description
			category: questionCategory
			parentId: null
			amountAnswers: 0
			completed: false
		}

		if (title== '') or (description== '')
			if (title== '')
				t.errorStateTitle.set(1)
			if (description == '')
				t.errorStateDescription.set(1)
		else
			Meteor.call "create_question", data, (error)->
				if error
					console.warn(error)
					sys.flashStatus("error-create-question")
				else
					sys.flashStatus("create-question")

			$('.question-title').val('')
			$('.question-description').val('')
			Modal.hide('createQuestionModal')
			FlowRouter.setQueryParams({action: null})

#######################################