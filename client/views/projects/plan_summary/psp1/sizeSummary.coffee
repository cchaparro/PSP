##########################################
Template.sizeSummary.helpers
	sizeData: () ->
		return db.plan_summary.findOne({ "projectId": FlowRouter.getParam("id") })?.total

	toDateData: ()->
		return db.users.findOne({_id: Meteor.userId()})?.profile

	addTwoValues: (v1,v2)->
		return v1 + v2

	addThreeValues: (v1,v2,v3) ->
		return v1 + v2 + v3

	addFourValues: (v1,v2,v3, v4) ->
		return v1 + v2 + v3 - v4

	newReusableValue : (type)->
		planSummary = db.plan_summary.findOne({ "projectId": FlowRouter.getParam("id") })
		estimated = 0
		actual = 0
		addData = planSummary.addLOC
		_.each addData, (addOption) ->
			if addOption.Estimated.nr
				estimated += addOption.Estimated.size
			if addOption.Actual.nr
				actual += addOption.Actual.size
		switch type
			when "estimated"
				return estimated
			when "actual"
				return actual
	newReusableHistoric : ()->
		historic = 0
		projects = db.projects.find({"completed":true}).fetch()
		_.each projects, (project)->
			unless project._id == FlowRouter.getParam("id")
				psProject = db.plan_summary.findOne({"projectId":project._id})?.addLOC
				if addOption.Actual.nr
					historic+=psProject.Actual.nr
		return historic

##########################################