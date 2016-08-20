##########################################
Template.planSummaryTemplate.helpers
	userData: () ->
		return db.users.findOne({_id: Meteor.userId()})

##########################################
Template.summaryTimeRow.helpers
	timeEstimatedStages: () ->
		return db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.timeEstimated

	totalValues: () ->
		planSummary = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.total

		return {
			estimatedTime: planSummary?.estimatedTime
			totalTime: planSummary?.totalTime
			totalToDate: @profile?.total?.time
			probeC: @?.settings?.probeC
			probeD: @?.settings?.probeD
		}

	planSummaryTime: (time) ->
		return sys.planSummaryTime(time)

	projectProbe: () ->
		return db.projects.findOne({_id: FlowRouter.getParam("id")})?.projectProbe

	isTotalTimeEmpty: () ->
		return @estimatedTime > 0

	estimationEditable: () ->
		projectStages = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.timeEstimated
		currentStage = _.findWhere projectStages, {finished: false}

		return true if currentStage.name == "Planeación"
		return false


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
		totalAmountDefects = db.defects.find({"projectId": FlowRouter.getParam("id")}).count()

		final = {}
		final.totalInjected = totalAmountDefects
		final.totalInjectedToDate = @profile?.total?.injected

		return final

##########################################
Template.summaryRemovedRow.helpers
	removedDefects: () ->
		return db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.removedEstimated

	totalRemovedValues: () ->
		totalAmountDefects = db.defects.find({"projectId": FlowRouter.getParam("id")}).count()

		final = {}
		final.totalRemoved = totalAmountDefects
		final.totalRemovedToDate = @profile?.total?.removed

		return final

##########################################