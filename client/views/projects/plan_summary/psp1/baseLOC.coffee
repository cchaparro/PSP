##########################################
Template.baseSummary.onCreated () ->
	@baseData = new ReactiveVar([])
	@deleteActive = new ReactiveVar(false)


Template.baseSummary.helpers
	createBaseData: ()->
		BaseLOC = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.baseLOC

		data = _.map BaseLOC, (base, index) ->
			return {
				position: index
				Estimated: base.Estimated
				Actual: base.Actual
			}
		Template.instance().baseData.set(data)

	baseData: ()->
		return Template.instance().baseData.get()

	activeDelete: ()->
		return Template.instance().deleteActive.get()



Template.baseSummary.events
	'click .base-add-row': (e,t) ->
		data = t.baseData.get()
		estimatedBase = { "name": "", "base": 0, "add": 0, "modified": 0, "deleted": 0 }
		actualBase = { "base": 0, "add": 0, "modified": 0, "deleted": 0 }

		data.push({
			position: data.length,
			Estimated: estimatedBase,
			Actual:actualBase
		})
		t.baseData.set(data)

	'blur .input-box input': (e,t) ->
		data = t.baseData.get()
		value = $(e.target).val()
		dataField = $(e.target).data('value')

		#This separated the "Estimated/Actual" form the field (e.g. base, name, modified)
		dataField = dataField.split(".")
		section = dataField[0]
		field = dataField[1]

		if section == "Estimated" and field == "deleted"
			baseField = data[@position]["Estimated"]["base"]
			if value > baseField
				$(e.target).val(0)
				return sys.flashStatus("base-deleted-error")

		if section == "Actual" and field == "modified"
			baseField = data[@position]["Actual"]["base"]
			if value > baseField
				$(e.target).val(0)
				return sys.flashStatus("base-modified-error")

		data[@position][section][field] = value
		t.baseData.set(data)

	'click .base-save-data': (e,t)->
		data = t.baseData.get()

		finalData = _.map data, (value) ->
			return {"Actual": value.Actual, "Estimated": value.Estimated}

		Meteor.call "update_base_size", FlowRouter.getParam("id"), finalData, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-project")
			else
				sys.flashStatus("save-project")
				t.deleteActive.set(false)

	'click .base-active-delete': (e,t) ->
		activeDelete = t.deleteActive.get()
		t.deleteActive.set(!activeDelete)

	'click .base-delete-row': (e,t) ->
		data = t.baseData.get()
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

			t.baseData.set(finalData)
			Meteor.call "update_base_size", FlowRouter.getParam("id"), finalData, (error) ->
				if error
					console.warn(error)

		else
			sys.flashStatus("size-delete-error")

##########################################
