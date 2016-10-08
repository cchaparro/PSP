##########################################
Template.planSummaryTemplate.helpers
	userData: () ->
		return db.users.findOne({_id: Meteor.userId()})

	actualLevelPSP: () ->
		return db.projects.findOne({"_id":FlowRouter.getParam("id")})?.levelPSP

	sizeForPSP0: ()->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		project = db.projects.findOne({_id: FlowRouter.getParam("id")})
		projectStages = _.filter planSummary?.timeEstimated, (stage) ->
			unless stage.finished
				return stage

		return true if project?.levelPSP == "PSP 0" and (projectStages.length < 2 or project?.completed)
		return false

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

	totalTimeEmpty: () ->
		return !(@estimatedTime > 0)

	estimationEditable: () ->
		projectStages = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.timeEstimated
		currentStage = _.findWhere projectStages, {finished: false}
		projectIsCompleted = db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed
		levelPSP = db.projects.findOne({"_id":FlowRouter.getParam("id")})?.levelPSP
		return false if projectIsCompleted
		return true if currentStage?.name == "Planeación" and levelPSP == "PSP 0"
		return false

Template.summaryTimeRow.events
	'blur .user-estimated': (e,t) ->
		value = $(e.target).val()

		data = {
			"total.estimatedTime": sys.minutesToTime(value)
		}

		# This is called here to update the estimatedTime for the PROBE D
		Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-save-summary-estimated")
			else
				sys.flashStatus("save-summary-estimated")


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

Template.sizePSP0.helpers
	sizeData: ()->
		return db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.total
	contentEditable: ()->
		project = db.projects.findOne({_id: FlowRouter.getParam("id")})
		return !(project?.completed)

Template.sizePSP0.events
	'blur .input-box input': (e,t) ->
		value = $(e.target).val()
		dataField = $(e.target).data('value')
		Meteor.call "update_plan_summary_size_psp0", FlowRouter.getParam("id"), dataField,value, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-save-size-summary")
			else
				sys.flashStatus("save-size-summary")
