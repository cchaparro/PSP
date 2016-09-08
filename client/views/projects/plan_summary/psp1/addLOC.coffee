##########################################
Template.addSummary.onCreated () ->
	@addData = new ReactiveVar([])
	# @deleteActive = new ReactiveVar(false)


Template.addSummary.helpers
	createaddData: ()->
		addLOC = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.addLOC

		data = _.map addLOC, (base, index) ->
			return {
				position: index
				Estimated: base.Estimated
				Actual: base.Actual
			}

		console.log data
		Template.instance().addData.set(data)

	addData: ()->
		return Template.instance().addData.get()

	# activeDelete: ()->
	# 	return Template.instance().deleteActive.get()



Template.baseSummary.events
	# 'click .base-add-row': (e,t) ->
	# 	data = t.addData.get()
	# 	estimatedBase = { "name": "", "base": 0, "add": 0, "modified": 0, "deleted": 0 }
	# 	actualBase = { "base": 0, "add": 0, "modified": 0, "deleted": 0 }

	# 	data.push({
	# 		position: data.length,
	# 		Estimated: estimatedBase,
	# 		Actual:actualBase
	# 	})
	# 	t.addData.set(data)

	'blur .input-box input': (e,t) ->
		data = t.addData.get()
		value = $(e.target).val()
		dataField = $(e.target).data('value')

		#This separated the "Estimated/Actual" form the field (e.g. base, name, modified)
		dataField = dataField.split(".")
		section = dataField[0]
		field = dataField[1]

		data[@position][section][field] = value
		t.addData.set(data)

	# 'click .base-save-data': (e,t)->
	# 	data = t.addData.get()

	# 	finalData = _.map data, (value) ->
	# 		return {"Actual": value.Actual, "Estimated": value.Estimated}

	# 	Meteor.call "update_base_size", FlowRouter.getParam("id"), finalData, (error) ->
	# 		if error
	# 			console.warn(error)
	# 			sys.flashStatus("error-project")
	# 		else
	# 			sys.flashStatus("save-project")
	# 			t.deleteActive.set(false)

	# 'click .base-active-delete': (e,t) ->
	# 	activeDelete = t.deleteActive.get()
	# 	t.deleteActive.set(!activeDelete)

	# 'click .base-delete-row': (e,t) ->
	# 	data = t.addData.get()
	# 	if data.length > 1
	# 		deletePos = @position
	# 		finalData = []

	# 		_.each data, (value, index) ->
	# 			unless value.position == deletePos
	# 				finalData.push({
	# 					position: index
	# 					Estimated: value.Estimated
	# 					Actual: value.Actual
	# 				})

	# 		t.addData.set(finalData)
	# 		sys.flashStatus("base-delete-success")
	# 	else
	# 		sys.flashStatus("base-delete-error")

##########################################
