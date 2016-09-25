#######################################
colors = ["#587291", "#00c1ed", "#00d5b6", "#ff8052", "#ffb427", "#F1E8B8", "#799e9c", "#91cda5"]
#######################################
Template.createProject.onCreated () ->
	@levelPSP = new ReactiveVar("PSP 0")
	#State 0(Default), State 1(Missing Field)
	@errorStateTitle = new ReactiveVar(0)
	@errorStateDescription = new ReactiveVar(0)

	amountProjects = db.projects.find({"projectOwner": Meteor.userId()}).count() % 8
	selectedColor = colors[amountProjects]
	@selectedColor = new ReactiveVar(selectedColor)


Template.createProject.helpers
	currentLevel: () ->
		return Template.instance().levelPSP.get()

	errorStateTitle: () ->
		return Template.instance().errorStateTitle.get()

	errorStateDescription: () ->
		return Template.instance().errorStateDescription.get()

	colorList: () ->
		colorOption = Template.instance().selectedColor.get()

		data = _.map colors, (color, index) ->
			return {selected: color == colorOption, color: color, position: index}

		return data

Template.createProject.events
	'click .color-option': (e,t) ->
		t.selectedColor.set(@color)

	'click .pry-level-option': (e,t) ->
		value = $(e.target).data('value')
		t.levelPSP.set(value)

	'keypress .pry-new-title': (e,t) ->
		title = $(e.target).val()
		if title!=''
			t.errorStateTitle.set(0)

	'keypress .pry-new-description': (e,t) ->
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
			color: t.selectedColor.get()
		}

		if (title== '') or (description== '')
			if (title== '')
				t.errorStateTitle.set(1)
			if (description == '')
				t.errorStateDescription.set(1)
		else
			Meteor.call "create_project", data, (error)->
				if error
					console.warn(error)
					sys.flashStatus("error-create-project")
				else
					sys.flashStatus("create-project")

			$('.pry-new-title').val('')
			$('.pry-new-description').val('')
			Modal.hide('createProjectModal')
			FlowRouter.setQueryParams({action: null})

#######################################