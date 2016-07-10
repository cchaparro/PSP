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
				sys.flashStatus("save-project")


##########################################
Template.summaryInjectedRow.helpers
	injectedDefects: () ->
		return db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.injectedEstimated

	totalInjectedValues: () ->
		user = db.users.findOne({_id: Meteor.userId()})
		totalAmountDefects = db.defects.find({"projectId": FlowRouter.getParam("id")}).count()

		final = {}
		final.totalInjected = totalAmountDefects
		final.totalInjectedToDate = user.profile.total.injected

		return final

##########################################
Template.summaryRemovedRow.helpers
	removedDefects: () ->
		return db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.removedEstimated

	totalRemovedValues: () ->
		user = db.users.findOne({_id: Meteor.userId()})
		totalAmountDefects = db.defects.find({"projectId": FlowRouter.getParam("id")}).count()

		final = {}
		final.totalRemoved = totalAmountDefects
		final.totalRemovedToDate = user.profile.total.removed

		return final

##########################################