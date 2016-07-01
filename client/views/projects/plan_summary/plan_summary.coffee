##########################################
Template.summaryTimeRow.helpers
	timeEstimatedStages: () ->
		return db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.timeEstimated

	totalValues: () ->
		planSummary = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.total
		user = db.users.findOne({_id: Meteor.userId()})

		final = {}
		final.estimatedTime = planSummary?.estimatedTime
		final.totalTime = planSummary?.totalTime
		final.totalToDate = user?.profile.total.time

		return final

	planSummaryTime: (time) ->
		return sys.planSummaryTime(time)


Template.summaryTimeRow.events
	'blur .psp-input': (e,t) ->
		value = $(e.target).val()

		data = {
			"total.estimatedTime": sys.minutesToTime(value)
		}
		Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
			if error
				console.warn(error)
			else
				sys.flashSuccess()


##########################################

##########################################