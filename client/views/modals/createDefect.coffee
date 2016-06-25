# ##########################################
Template.createDefect.onCreated () ->
	@defect = new ReactiveVar({})
	@defectId = new ReactiveVar('')
	@timeStatus = new ReactiveVar(false)
	@defectState = new ReactiveVar(0)
	@timeStarted = new ReactiveVar(0)

	#State 0(Default), State 1(Missing Field)
	@errorState = new ReactiveVar(0)

	if @.data
		Template.instance().defectId.set(@.data._id)
		Template.instance().defectState.set(1)
		Template.instance().defect.set({
			"typeDefect": @.data.typeDefect
			"injected": @.data.injected
			"removed": @.data.removed
			"fixCount": @.data.fixCount
			"description": @.data.description
			"parentId": ""
		})
	else
		Template.instance().defect.set({
			"typeDefect":"Tipo de defecto"
			"injected":"Inyectado"
			"removed":"Removido"
			"fixCount": "1"
			"description": ""
			"parentId": ""
		})

Template.createDefect.helpers
	allDefectTypes: () ->
		defectTypes = db.defect_types.findOne({"defectTypeOwner": Meteor.userId()})
		return defectTypes?.defects

	defectData: () ->
		return Template.instance().defect.get()

	descriptionText: () ->
		return $('.create-defect-description').val() isnt ''

	injectedPhases: () ->
		pid = FlowRouter.getParam("id")
		Project = db.plan_summary.findOne({projectId: pid})
		return Project?.InjectedEstimated

	removedPhases: () ->
		pid = FlowRouter.getParam("id")
		Defect = Template.instance().defect.get()
		injected = Defect.injected

		projectStages = db.plan_summary.findOne({projectId: pid}).RemovedEstimated

		unless injected != "Inyectado"
			return projectStages

		validStages = []
		state = false
		_.each projectStages, (stage) ->
			if state
				validStages.push(stage)
			if stage.name == injected
				state = true
		return validStages


	errorState: () ->
		return Template.instance().errorState.get()

	timeStatus: () ->
		return Template.instance().timeStatus.get()

	ifLoadsData: () ->
		Defect_State = Template.instance().defectState.get()
		if Defect_State == 1
			return true
		else
			return false

	projectTotalTime: () ->
		DefectId = Template.instance().defectId.get()
		time = 0
		if (DefectId isnt '')
			Defect = db.defects.findOne({_id: DefectId, "defectOwner": Meteor.userId()})
			time = Defect.time

		return sys.displayTime(time)


Template.createDefect.events
	'click .create-sel-defect-type': (e,t) ->
		type = $(e.target).data('value')
		Defect = t.defect.get()
		Defect.typeDefect = type
		t.defect.set(Defect)

	'click .create-sel-defect-injected': (e,t) ->
		injected = $(e.target).data('value')
		Defect = t.defect.get()
		Defect.injected = injected
		Defect.removed = "Removido"
		t.defect.set(Defect)

	'click .create-sel-defect-removed': (e,t) ->
		removed = $(e.target).data('value')
		Defect = t.defect.get()
		Defect.removed = removed
		t.defect.set(Defect)

	'change .create-defect-fix-count': (e,t) ->
		fixCount = $(e.target).val()
		Defect = t.defect.get()
		Defect.fixCount = fixCount
		t.defect.set(Defect)

	'change .create-defect-description': (e,t) ->
		description = $(e.target).val()
		Defect = t.defect.get()
		Defect.description = description
		t.defect.set(Defect)

	'click .pry-modal-create': (e,t) ->
		date = $('.new-defect-date').val()
		projectId = FlowRouter.getParam("id")
		DefectId = t.defectId.get()
		TimeStarted = t.timeStarted.get()
		Defect = t.defect.get()

		if TimeStarted == 0
			totalTime = 0
		else
			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)

		if !(Defect.description!= '') or (Defect.typeDefect == "Tipo de defecto") or (Defect.injected == "Inyectado") or (Defect.removed == "Removido")
			t.errorState.set(1)

		else if (DefectId!= '')
			Meteor.call "update_defect", DefectId, Meteor.userId(), projectId, date, Defect, totalTime, (err) ->
				if err
					#sys.flashError()
					console.log ("Error updating a Defect: " + err)
				else
					t.timeStarted.set(0)
					Modal.hide('createDefectModal')
					#sys.flashSuccess()
		else
			Meteor.call "create_defect", Meteor.userId(), projectId, date, Defect, parseInt(totalTime), (error) ->
				if error
					sys.flashError()
					console.log "Error creating a new defect"
					console.warn(error)
				else
					Modal.hide('createDefectModal')
					sys.flashSuccess()

	'click .close-error-box': (e,t) ->
		t.errorState.set(0)

	'click .fa-play': (e,t) ->
		t.timeStarted.set(new Date())
		t.timeStatus.set(true)

	'click .fa-pause': (e,t) ->
		DefectId = t.defectId.get()
		TimeStarted = t.timeStarted.get()

		unless TimeStarted == 0
			date = $('.new-defect-date').val()
			projectId = FlowRouter.getParam("id")
			Defect = t.defect.get()

			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)
			t.timeStatus.set(false)

			if (DefectId!= '')
				Meteor.call "update_defect", DefectId, Meteor.userId(), projectId, date, Defect, totalTime, (error) ->
					if error
						sys.flashError()
						console.log "Error updating a existing Defect"
						console.warn(error)
					else
						t.timeStarted.set(0)

			else
				Meteor.call "create_defect", Meteor.userId(), projectId, date, Defect, totalTime, (error, result) ->
					t.defectId.set(result)
					if error
						sys.flashError()
						console.log "Error creating a new defect"
					else
						t.timeStarted.set(0)

	'click .defect-son': (e,t) ->
		TimeStarted = t.timeStarted.get()
		unless TimeStarted == 0
			date = $('.new-defect-date').val()
			projectId = FlowRouter.getParam("id")
			DefectId = t.defectId.get()
			Defect = t.defect.get()

			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)
			t.timeStatus.set(false)

			if (DefectId!= '')
				Meteor.call "update_defect", DefectId, Meteor.userId(), projectId, date, Defect, totalTime, (error) ->
					if error
						sys.flashError()
						console.log "Error updating the sonf Defect"
						console.warn(error)
					else
						t.timeStarted.set(0)
						sys.flashSuccess()

		t.defectState.set(0)
		t.defect.set({
			"typeDefect":"Tipo de defecto"
			"injected":"Inyectado"
			"removed":"Removido"
			"fixCount": "1"
			"description": ""
			"parentId": t.defectId.get()
		})
		t.defectId.set('')

# ##########################################