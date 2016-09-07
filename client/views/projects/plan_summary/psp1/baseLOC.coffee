##########################################
Template.baseSummary.onCreated () ->
	#Meteor.subscribe "projectView"
	@baseData = new ReactiveVar([])


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

		data[@position][section][field] = value
		t.baseData.set(data)

	'click .base-save-data': (e,t)->
		console.log t.baseData.get()

	# 'click .delete-row': (e,t)->
	# 	baseTmp = t.baseData.get()
	# 	if baseTmp.length > 1
	# 		currentBase = @
	# 		pos = 1
	# 		bases = []
	# 		_.each baseTmp, (base) ->
	# 			unless base.position == currentBase.position
	# 				bases.push({position: pos, Estimated: base.Estimated, Actual: base.Actual})
	# 				pos += 1
	# 				t.baseData.set(bases)
	# 			else
	# 				sys.flashStatus("empty-delete")

	# 'click .save-rows': (e,t)->
	# 	bases = t.baseData.get()
	# 	basesList = _.map bases, (base) ->
	# 		return {Estimated: base.Estimated, Actual: base.Actual}
	# 	console.log basesList

	# 	Meteor.call "update_base_size", FlowRouter.getParam("id"), basesList, (error) ->
	# 		if error
	# 			console.warn(error)
	# 			sys.flashStatus("error-project")
	# 		else
	# 			sys.flashStatus("save-project")

##########################################
