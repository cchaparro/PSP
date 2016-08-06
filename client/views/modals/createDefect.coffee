# ##########################################
Template.createDefect.onCreated () ->
	@defect = new ReactiveVar({})
	@defectId = new ReactiveVar('')
	@defectState = new ReactiveVar(0)
	@timeStatus = new ReactiveVar(true)
	currentDate = new Date()
	@timeStarted = new ReactiveVar(currentDate)

	#State 0(Default), State 1(Missing Field)
	@errorState = new ReactiveVar(0)

	if @data
		Template.instance().defectId.set(@data._id)
		Template.instance().defectState.set(1)
		Template.instance().defect.set(@data)
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
		userDefectListId = db.projects.findOne({_id: FlowRouter.getParam("id")})?.defectTypesId
		return db.defect_types.findOne({_id: userDefectListId})?.defects

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
		DefectId = t.defectId.get()
		TimeStarted = t.timeStarted.get()
		Defect = t.defect.get()

		if TimeStarted == 0
			totalTime = 0
		else
			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)

		data = {
			"defectOwner": Meteor.userId()
			"projectId": FlowRouter.getParam("id")
			"createdAt": new Date()
			"time": totalTime
			"created": true
		}
		data = _.extend Defect, data

		if !(Defect.description!= '') or (Defect.typeDefect == "Tipo de defecto") or (Defect.injected == "Inyectado") or (Defect.removed == "Removido")
			t.errorState.set(1)

		else if DefectId!= ''
			#console.log "Di cick a guardar a un proyecto que ya existia"
			Meteor.call "update_defect", DefectId, data, true, true, (error) ->
				if error
					sys.flashStatus("error-defect")
					console.log "Error updating a Defect"
					console.warn(error)
				else
					t.timeStarted.set(0)
					Modal.hide('createDefectModal')
					sys.flashStatus("save-defect")
		else
			#console.log "Creando proyecto nuevo y la di guardar directo sin click en play/pause"
			Meteor.call "create_defect", data, true, true, (error) ->
				if error
					sys.flashStatus("error-defect")
					console.log "Error creating a new defect"
					console.warn(error)
				else
					Modal.hide('createDefectModal')
					sys.flashStatus("create-defect")

	'click .close-error-box': (e,t) ->
		t.errorState.set(0)

	'click .fa-play': (e,t) ->
		t.timeStarted.set(new Date())
		t.timeStatus.set(true)

	'click .fa-pause': (e,t) ->
		DefectId = t.defectId.get()
		Defect = t.defect.get()
		TimeStarted = t.timeStarted.get()

		unless TimeStarted == 0
			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)
			t.timeStatus.set(false)

			data = {
				"defectOwner": Meteor.userId()
				"projectId": FlowRouter.getParam("id")
				"createdAt": new Date()
				"time": totalTime
			}
			data = _.extend Defect, data

			unless data.created
				data.created = false

			if DefectId!= ''
				#console.log "Cuando das play y pause cuando abriste un proyecto"
				Meteor.call "update_defect", DefectId, data, false, true, (error) ->
					if error
						sys.flashStatus("error-defect")
						console.log "Error updating a existing Defect"
						console.warn(error)
					else
						t.timeStarted.set(0)

			else
				#console.log "Nuevo defecto das click play y luego pause"
				Meteor.call "create_defect", data, false, true, (error, result) ->
					if error
						sys.flashStatus("error-defect")
						console.log "Error creating a new defect"
					else
						t.timeStarted.set(0)
						t.defectId.set(result)


	'click .defect-create-son': (e,t) ->
		TimeStarted = t.timeStarted.get()
		unless TimeStarted == 0
			DefectId = t.defectId.get()
			Defect = t.defect.get()

			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)
			t.timeStatus.set(false)

			data = {
				"defectOwner": Meteor.userId()
				"projectId": FlowRouter.getParam("id")
				"createdAt": new Date()
				"time": totalTime
			}
			data = _.extend Defect, data

			if DefectId!= ''
				Meteor.call "update_defect", DefectId, data, false, true, (error) ->
					if error
						sys.flashStatus("error-defect")
						console.log "Error updating the son Defect"
						console.warn(error)
					else
						currentDate = new Date()
						t.timeStarted.set(currentDate)
						sys.flashStatus("save-defect")

		t.timeStatus.set(true)
		currentDate = new Date()
		t.timeStarted.set(currentDate)

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