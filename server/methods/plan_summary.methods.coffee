#######################################
Meteor.methods
	create_plan_summary: (userId, projectId, levelPSP) ->
		syssrv.createPlanSummary(userId, projectId, levelPSP)


	update_plan_summary: (pid, data) ->
		db.plan_summary.update({"projectId": pid, "summaryOwner": Meteor.userId()}, {$set: data})


	#This is for completing a stage or updating the time of the current stage
	update_time_stage: (pid, stage, finishStage=false, reset_timeStarted=false) ->
		planSummary = db.plan_summary.findOne({"projectId": pid, "summaryOwner": Meteor.userId()})

		# the input stage is the stage that just had a new amount of time registered
		currentStage = _.findWhere planSummary?.timeEstimated, {name: stage.name}
		currentStage.time = stage.time + currentStage.time

		if finishStage
			currentStage.finished = true

		console.log planSummary.timeEstimated

		data = {
			"timeEstimated": planSummary.timeEstimated
			"total.totalTime": planSummary.total.totalTime + stage.time
		}

		if reset_timeStarted
			data.timeStarted = "false"

		db.plan_summary.update({"projectId": pid}, {$set: data})

	update_timeStarted: (pid, timeStarted) ->
		db.plan_summary.update({"projectId": pid}, {$set: {"timeStarted": timeStarted}})
#######################################