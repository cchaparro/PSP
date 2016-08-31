###########################################
# titleStatus true is Create title and false is Modify title
titleStatus = new ReactiveVar(true)
defectsParent = new ReactiveVar(false)
defectData = new ReactiveVar({})
defectId = new ReactiveVar('')
timeStarted = new ReactiveVar(false)

###########################################
Template.createDefectModal.helpers
	displayTitle: () ->
		if titleStatus.get()
			return "Crear nuevo defecto"
		else
			return "Modificar defecto"

	parentId: () ->
		return defectsParent.get()


Template.createDefectModal.events
	'click .defect-header-description a': (e,t) ->
		parentId = defectsParent.get()
		parentData = db.defects.findOne({_id: parentId})

		defectData.set(parentData)
		defectId.set(parentData._id)
		titleStatus.set(false)
		timeStarted.set(new Date())

		if parentData.parentId?
			defectsParent.set(parentData.parentId)
		else
			defectsParent.set(false)

###########################################
Template.createDefect.onCreated () ->
	#State 0(Default), State 1(Missing Field)
	@errorState = new ReactiveVar(0)

	# Start data clean when you open a defect modal
	titleStatus.set(true)
	defectId.set('')
	defectData.set({})
	defectsParent.set(false)
	timeStarted.set(new Date())

	if @data
		if @data.parentId
			defectsParent.set(@data.parentId)

		defectId.set(@data._id)
		defectData.set(@data)
		titleStatus.set(false)
	else
		defectData.set({
			"typeDefect":"Elegir tipo"
			"injected":"Elegir etapa"
			"removed":"Elegir etapa"
			"fixCount": "1"
			"description": ""
			"parentId": ""
		})


Template.createDefect.helpers
	allDefectTypes: () ->
		userDefectListId = db.projects.findOne({_id: FlowRouter.getParam("id")})?.defectTypesId
		return db.defect_types.findOne({_id: userDefectListId})?.defects

	defectData: () ->
		return defectData.get()

	descriptionText: () ->
		description = $('.defect-modal-description').val()
		return description?.length > 0

	injectedPhases: () ->
		return db.plan_summary.findOne({projectId: FlowRouter.getParam("id")})?.injectedEstimated

	removedPhases: () ->
		Defect = defectData.get()
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
		return timeStarted.get()

	ifLoadsData: () ->
		return titleStatus.get()

	projectTotalTime: () ->
		DefectId = defectId.get()
		time = 0
		if (DefectId!= '')
			Defect = db.defects.findOne({_id: DefectId, "defectOwner": Meteor.userId()})
			time = Defect.time

		return sys.displayShortTime(time)


Template.createDefect.events
	'click .defect-select-field': (e,t) ->
		field = $(e.target).data('value')
		type = $(e.target).data('type')
		Defect = defectData.get()

		if type == "typeDefect"
			Defect[type] = field
		else if type == "injected"
			Defect.injected = field
			Defect.removed = "Elegir etapa"
		else
			Defect.removed = field

		defectData.set(Defect)

	'change .defect-input-field': (e,t) ->
		field = $(e.target).data('field')
		value = $(e.target).val()
		Defect = defectData.get()
		Defect[field] = value
		defectData.set(Defect)

	'click .pry-modal-create': (e,t) ->
		DefectId = defectId.get()
		TimeStarted = timeStarted.get()
		Defect = defectData.get()

		if TimeStarted
			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)
		else
			totalTime = 0

		data = {
			"defectOwner": Meteor.userId()
			"projectId": FlowRouter.getParam("id")
			"createdAt": new Date()
			"time": totalTime
			"created": true
		}
		data = _.extend Defect, data

		if !(Defect.description!= '') or (Defect.typeDefect == "Elegir tipo") or (Defect.injected == "Elegir etapa") or (Defect.removed == "Elegir etapa")
			t.errorState.set(1)
			data.created = false

		else if DefectId!= ''
			#console.log "Di cick a guardar a un proyecto que ya existia"
			Meteor.call "update_defect", DefectId, data, true, true, (error) ->
				if error
					sys.flashStatus("error-defect")
					console.log "Error updating a Defect"
					console.warn(error)
				else
					timeStarted.set(false)
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
		timeStarted.set(new Date())

	'click .fa-pause': (e,t) ->
		DefectId = defectId.get()
		Defect = defectData.get()
		TimeStarted = timeStarted.get()

		if TimeStarted
			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)

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
						timeStarted.set(false)

			else
				#console.log "Nuevo defecto das click play y luego pause"
				Meteor.call "create_defect", data, false, true, (error, result) ->
					if error
						sys.flashStatus("error-defect")
						console.log "Error creating a new defect"
					else
						timeStarted.set(false)
						defectId.set(result)


	'click .defect-create-son': (e,t) ->
		TimeStarted = timeStarted.get()
		if TimeStarted
			DefectId = defectId.get()
			Defect = defectData.get()

			totalTime = new Date() - TimeStarted
			totalTime = parseInt(totalTime)

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
						timeStarted.set(currentDate)
						sys.flashStatus("save-defect")

		currentDate = new Date()
		timeStarted.set(currentDate)

		defectData.set({
			"typeDefect":"Elegir tipo"
			"injected":"Elegir etapa"
			"removed":"Elegir etapa"
			"fixCount": "1"
			"description": ""
			"parentId": defectId.get()
		})
		defectId.set('')
		titleStatus.set(true)

# ##########################################