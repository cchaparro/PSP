# ##########################################
Template.createDefect.onCreated () ->
	@defect = new ReactiveVar({})
	@defectId = new ReactiveVar('')
	@timeStatus = new ReactiveVar(false)
	@defectState = new ReactiveVar(0)
	@timeStarted = new ReactiveVar(0)

	#State 0(Default), State 1(Missing Field)
	@errorState = new ReactiveVar(0)

	if @data
		Template.instance().defectId.set(@.data._id)
		Template.instance().defectState.set(1)
		Template.instance().defect.set(@data)
	else
		Template.instance().defect.set(Meteor.settings.public.defectTemplate)


Template.createDefect.helpers
	allDefectTypes: () ->
		return db.defect_types.findOne({"defectTypeOwner": Meteor.userId()})?.defects

	defectData: () ->
		return Template.instance().defect.get()

	descriptionText: () ->
		return $('.create-defect-description').val() isnt ''

	injectedPhases: () ->
		return db.plan_summary.findOne({projectId: FlowRouter.getParam("id")})?.injectedEstimated

	removedPhases: () ->
		Defect = Template.instance().defect.get()
		injected = Defect.injected

		projectStages = db.plan_summary.findOne({projectId: FlowRouter.getParam("id")}).removedEstimated

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
		return Defect_State == 1

	projectTotalTime: () ->
		DefectId = Template.instance().defectId.get()
		time = 0
		if (DefectId!= '')
			Defect = db.defects.findOne({_id: DefectId, "defectOwner": Meteor.userId()})
			time = Defect.time

		return sys.displayTime(time)


Template.createDefect.events
	'click .defect-select-field': (e,t) ->
		field = $(e.target).data('value')
		type = $(e.target).data('type')
		Defect = t.defect.get()

		if type == "typeDefect"
			Defect[type] = field
		else if type == "injected"
			Defect.injected = field
			Defect.removed = "Removido"
		else
			Defect.removed = field

		t.defect.set(Defect)

	'change .defect-input-field': (e,t) ->
		field = $(e.target).data('field')
		value = $(e.target).val()
		Defect = t.defect.get()
		Defect[field] = value
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
			Meteor.call "update_defect", DefectId, Meteor.userId(), projectId, date, Defect, totalTime, true, (error) ->
				if error
					sys.flashError()
					console.log "Error updating a Defect"
					console.warn(error)
				else
					t.timeStarted.set(0)
					Modal.hide('createDefectModal')
					sys.flashSuccess()
		else
			Meteor.call "create_defect", Meteor.userId(), projectId, date, Defect, parseInt(totalTime), true, (error) ->
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

	'click .defect-create-son': (e,t) ->
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
						console.log "Error updating the son Defect"
						console.warn(error)
					else
						t.timeStarted.set(0)
						sys.flashSuccess()

		t.defectState.set(0)
		defectTemplate = Meteor.settings.public.defectTemplate
		defectTemplate.parentId = t.defectId.get()

		t.defect.set(defectTemplate)
		t.defectId.set('')

# ##########################################