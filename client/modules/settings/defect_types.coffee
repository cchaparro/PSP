defectTypeList = new ReactiveVar([])

Template.defectTypeSettingsTemplate.onCreated ()->
	Meteor.subscribe "projectSettings"
	@displayWarning = new ReactiveVar(false)

	@autorun ->
		userId = Meteor.userId()
		defectTypeId = db.users.findOne({_id: userId})?.defectTypes?.current
		defectTypes = db.defect_types.findOne({_id: defectTypeId})?.defects

		defects = []
		_.each defectTypes, (defect, position) ->
			defects.push({
				position: position
				name: defect.name
				description: defect.description
			})

		defectTypeList.set(defects)


Template.defectTypeSettingsTemplate.helpers
	defectTypes: () ->
		return defectTypeList.get()

	displayWarning: () ->
		return Template.instance().displayWarning.get()


Template.defectTypeSettingsTemplate.events
	'blur .defect-type-title': (e,t) ->
		defectList = defectTypeList.get()
		value = $(e.target).text()

		defectList[@position-1].name = value
		defectTypeList.set(defectList)

	'blur .defect-type-description': (e,t) ->
		defectList = defectTypeList.get()
		value = $(e.target).text()

		defectList[@position-1].description = value
		defectTypeList.set(defectList)

	'click .defect-type-delete': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		defectList = defectTypeList.get()
		currentDefect = @

		defects = []
		_.each defectList, (defect, position) ->
			unless defect.position == currentDefect.position
				defects.push({position: position, name: defect.name, description: defect.description})

		defectTypeList.set(defects)

	'click .save-defect-types': (e,t) ->
		defects = defectTypeList.get()

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

		defectTypeList.set(defects)


Template.createDefectTypeAction.events
	'click .create-defect-type': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		defectList = defectTypeList.get()

		defectList.push({
			position: defectList.length + 1
			name: "Nuevo tipo de defecto"
			description: "Aquí va la descripción del nuevo tipo de defecto"
		})

		defectTypeList.set(defectList)
		sys.flashStatus("add-defect-dype")
