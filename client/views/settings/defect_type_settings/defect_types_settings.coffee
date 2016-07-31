##################################################
Template.defectTypeSettingsTemplate.onCreated ()->
	Meteor.subscribe "projectSettings"
	@defectTypeList = new ReactiveVar([])
	@displayWarning = new ReactiveVar(false)


Template.defectTypeSettingsTemplate.helpers
	createDefectList: () ->
		defectTypeId = db.users.findOne({_id: Meteor.userId()})?.defectTypes?.current
		defectTypes = db.defect_types.findOne({_id: defectTypeId})?.defects

		pos = 1
		defects = []
		_.each defectTypes, (defect) ->
			defects.push({position: pos, name: defect.name, description: defect.description})
			pos += 1

		Template.instance().defectTypeList.set(defects)
		return

	defectTypes: () ->
		return Template.instance().defectTypeList.get()

	displayWarning: () ->
		return Template.instance().displayWarning.get()


Template.defectTypeSettingsTemplate.events
	'blur .psp-input': (e,t) ->
		defectList = t.defectTypeList.get()
		value = $(e.target).val()

		defectList[@position-1].name = value
		t.defectTypeList.set(defectList)

	'blur .psp-textarea': (e,t) ->
		defectList = t.defectTypeList.get()
		value = $(e.target).val()

		defectList[@position-1].description = value
		t.defectTypeList.set(defectList)

	'click .add-defect-type': (e,t) ->
		defectList = t.defectTypeList.get()
		defectList.push({position: defectList.length+1, name: "Nuevo tipo de defecto", description: "Aquí va la descripción del nuevo tipo de defecto"})
		t.defectTypeList.set(defectList)

	'click .delete-defect-type': (e,t) ->
		defectList = t.defectTypeList.get()
		currentDefect = @

		pos = 1
		defects = []
		_.each defectList, (defect) ->
			unless defect.position == currentDefect.position
				defects.push({position: pos, name: defect.name, description: defect.description})
				pos += 1

		t.defectTypeList.set(defects)

	'click .save-defect-types': (e,t) ->
		defects = t.defectTypeList.get()

		defectList = _.map defects, (defect) ->
			return {name: defect.name, description: defect.description}

		Meteor.call "create_defect_types", Meteor.userId(), defectList, true, (error) ->
			if error
				console.log "Error creating defect types file"
				console.warn(error)
			else
				t.displayWarning.set(true)
				sys.flashStatus("update-defect-types")

	'click .reset-defect-types': (e,t) ->
		defectTypeId = db.users.findOne({_id: Meteor.userId()})?.defectTypes?.default
		defectTypes = db.defect_types.findOne({_id: defectTypeId})?.defects

		pos = 1
		defects = []
		_.each defectTypes, (defect) ->
			defects.push({position: pos, name: defect.name, description: defect.description})
			pos += 1

		t.defectTypeList.set(defects)

##################################################