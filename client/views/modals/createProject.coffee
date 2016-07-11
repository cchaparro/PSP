#######################################
Template.createProject.onCreated () ->
	@levelPSP = new ReactiveVar("PSP 0")
	#State 0(Default), State 1(Missing Field)
	@errorStateTitle = new ReactiveVar(0)
	@errorStateDescription = new ReactiveVar(0)


Template.createProject.helpers
	Level: () ->
		return Template.instance().levelPSP.get()

	errorStateTitle: () ->
		return Template.instance().errorStateTitle.get()

	errorStateDescription: () ->
		return Template.instance().errorStateDescription.get()


Template.createProject.events
	'click .pry-level-option': (e,t) ->
		value = $(e.target).data('value')
		t.levelPSP.set(value)

	'blur .pry-new-title': (e,t) ->
		title = $(e.target).val()
		if title!=''
			t.errorStateTitle.set(0)

	'blur .pry-new-description': (e,t) ->
		description = $(e.target).val()
		if description!=''
			t.errorStateDescription.set(0)

	'click .pry-modal-create': (e,t) ->
		title = $('.pry-new-title').val()
		description = $('.pry-new-description').val()
		levelPSP = t.levelPSP.get()

		data = {
			title: title
			description: description
			levelPSP: levelPSP
			parendId: null
		}

		if (title== '') or (description== '')
			if (title== '')
				t.errorStateTitle.set(1)
			if (description== '')
				t.errorStateDescription.set(1)
		else
			Meteor.call "create_project", data, (error)->
				if error
					console.log "Error creating a new project"
					console.warn(error)
				else
					sys.flashStatus("create-project")

			$('.pry-new-title').val('')
			$('.pry-new-description').val('')
			Modal.hide('createProjectModal')
			#FlowRouter.setQueryParams({action: null})

#######################################