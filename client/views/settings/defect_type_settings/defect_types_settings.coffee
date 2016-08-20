##################################################
Template.defectTypeSettingsTemplate.onCreated ()->
	Meteor.subscribe "projectSettings"
	@defectTypeList = new ReactiveVar([])
	@displayWarning = new ReactiveVar(false)
	@selectedRow = new ReactiveVar(0)


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

	selectedRow: () ->
		return Template.instance().selectedRow.get() == @position


Template.defectTypeSettingsTemplate.events
	'click .defect-type-box': (e,t) ->
		t.selectedRow.set(@position)

	'blur .defect-type-title': (e,t) ->
		defectList = t.defectTypeList.get()
		value = $(e.target).text()

		defectList[@position-1].name = value
		t.defectTypeList.set(defectList)

	'blur .defect-type-description': (e,t) ->
		defectList = t.defectTypeList.get()
		value = $(e.target).text()

		defectList[@position-1].description = value
		t.defectTypeList.set(defectList)

	'click .add-defect-type': (e,t) ->
		defectList = t.defectTypeList.get()
		defectList.push({position: defectList.length+1, name: "Nuevo tipo de defecto", description: "Aquí va la descripción del nuevo tipo de defecto"})
		t.defectTypeList.set(defectList)
		t.selectedRow.set(defectList.length)

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
				t.selectedRow.set(0)
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
		t.selectedRow.set(0)

##################################################