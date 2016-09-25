##########################################
Template.reusedSummary.onCreated () ->
	@reusedData = new ReactiveVar([])
	@deleteActive = new ReactiveVar(false)


Template.reusedSummary.helpers
	createreusedData: ()->
		BaseLOC = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.reusedLOC

		data = _.map BaseLOC, (base, index) ->
			return {
				position: index
				Estimated: base.Estimated
				Actual: base.Actual
			}
		Template.instance().reusedData.set(data)

	reusedData: ()->
		return Template.instance().reusedData.get()

	activeDelete: ()->
		return Template.instance().deleteActive.get()



Template.reusedSummary.events
	'click .reused-add-row': (e,t) ->
		data = t.reusedData.get()
		estimatedBase = { "name": "", "size": 0 }
		actualBase = { "size": 0 }

		data.push({
			position: data.length,
			Estimated: estimatedBase,
			Actual:actualBase
		})
		t.reusedData.set(data)

	'blur .input-box input': (e,t) ->
		data = t.reusedData.get()
		value = $(e.target).val()
		dataField = $(e.target).data('value')

		#This separated the "Estimated/Actual" form the field (e.g. base, name, modified)
		dataField = dataField.split(".")
		section = dataField[0]
		field = dataField[1]

		data[@position][section][field] = value
		t.reusedData.set(data)

	'click .reused-save-data': (e,t)->
		data = t.reusedData.get()

		finalData = _.map data, (value) ->
			return {"Actual": value.Actual, "Estimated": value.Estimated}

		Meteor.call "update_reused_size", FlowRouter.getParam("id"), finalData, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-save-size-summary")
			else
				sys.flashStatus("save-size-summary")
				t.deleteActive.set(false)

	'click .reused-active-delete': (e,t) ->
		activeDelete = t.deleteActive.get()
		t.deleteActive.set(!activeDelete)

	'click .reused-delete-row': (e,t) ->
		data = t.reusedData.get()
		if data.length > 1
			deletePos = @position
			finalData = []

			_.each data, (value, index) ->
				unless value.position == deletePos
					finalData.push({
						position: index
						Estimated: value.Estimated
						Actual: value.Actual
					})

			t.reusedData.set(finalData)
			Meteor.call "update_reused_size", FlowRouter.getParam("id"), finalData, (error) ->
				if error
					console.warn(error)

		else
			sys.flashStatus("size-delete-error")

##########################################
