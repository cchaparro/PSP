#######################################
Template.createProject.onCreated () ->
	@levelPSP = new ReactiveVar("PSP 0")
	#State 0(Default), State 1(Missing Field)
	#@errorState = new ReactiveVar(0)


Template.createProject.helpers
	Level: () ->
		console.log Template.instance().levelPSP.get()
		return Template.instance().levelPSP.get()

	titleText: () ->
		title = $('.new-pry-title').val()
		return sys.isNotEmpty(title)

	descriptionText: () ->
		title = $('.new-pry-description').val()
		return sys.isNotEmpty(title)


Template.createProject.events
	'click .pry-level-option': (e,t) ->
		value = $(e.target).data('value')
		t.levelPSP.set(value)


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

		if (title is '') or (description is '')
			console.log "no tengo titulo o descripcion"
		else
			Meteor.call "create_project", data, (error, result)->
				if error
					console.log "Error creating a new project"
				else
					Meteor.call "create_plan_summary", Meteor.userId(), result, levelPSP, (error) ->
						if error
							console.log "Error creating new projects Plan Summary"
						else
							console.log "Plan summary created successfully!"
							sys.flashSuccess()

			$('.pry-new-title').val('')
			$('.pry-new-description').val('')
			Modal.hide('createProjectModal')
			#FlowRouter.setQueryParams({action: null})

#######################################