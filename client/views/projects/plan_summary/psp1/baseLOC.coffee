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
	'click .add-row': (e,t) ->
		baseTmp = t.baseData.get()
		estimatedBase={
			"name": "",
			"base": 0,
			"add": 0,
			"modified": 0,
			"deleted": 0
		}
		actualBase = {
			"base": 0,
			"add": 0,
			"modified": 0,
			"deleted": 0
		}
		row = {
			position:baseTmp.length+1,
			Estimated:estimatedBase,
			Actual:actualBase
		}
		baseTmp.push(row)
		t.baseData.set(baseTmp)

	'blur .psp-input': (e,t) ->
		baseTmp = t.baseData.get()
		input = $(e.target)
		switch input.attr("name")
			when "name"
				baseTmp[@position-1].Estimated.name = input.val()
				t.baseData.set(baseTmp)
				return
			when "eBas"
				baseTmp[@position-1].Estimated.base = input.val()
				t.baseData.set(baseTmp)
				return
			when "eAdd"
				baseTmp[@position-1].Estimated.add = input.val()
				t.baseData.set(baseTmp)
				return
			when "eMod"
				baseTmp[@position-1].Estimated.modified = input.val()
				t.baseData.set(baseTmp)
				return
			when "eDel"
				baseTmp[@position-1].Estimated.deleted = input.val()
				t.baseData.set(baseTmp)
				return
			when "aBas"
				baseTmp[@position-1].Actual.base = input.val()
				t.baseData.set(baseTmp)
				return
			when "aAdd"
				baseTmp[@position-1].Actual.add = input.val()
				t.baseData.set(baseTmp)
				return
			when "aMod"
				baseTmp[@position-1].Actual.modified = input.val()
				t.baseData.set(baseTmp)
				return
			when "aDel"
				baseTmp[@position-1].Actual.deleted = input.val()
				t.baseData.set(baseTmp)
				return

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
