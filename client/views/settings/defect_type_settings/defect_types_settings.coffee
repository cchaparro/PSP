##################################################
Template.defectTypeSettingsTemplate.onCreated ()->
	Meteor.subscribe "projectSettings"
	@defectTypeList = new ReactiveVar([])

Template.defectTypeSettingsTemplate.helpers
	defectType: () ->
		defectTypeId = db.users.findOne({_id: Meteor.userId()})?.defectTypes?.current
		defectTypes = db.defect_types.findOne({_id: defectTypeId})?.defects

		pos = 1
		defects = []
		_.each defectTypes, (defect) ->
			defects.push({position: pos, name: defect.name, description: defect.description})
			pos += 1

		Template.instance().defectTypeList.set(defects)

		return defects


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
		console.log t.defectTypeList.get()

	'click .save-defect-types': (e,t) ->
		defects = t.defectTypeList.get()

		defectList = _.map defects, (defect) ->
			return {name: defect.name, description: defect.description}

		Meteor.call "create_defect_types", Meteor.userId(), defectList, true, (error) ->
			if error
				console.log "Error creating defect types file"
				console.warn(error)
			else
				sys.flashStatus("update-defect-types")

	'click .reset-defect-types': (e,t) ->
		console.log "di click a reset"

##################################################