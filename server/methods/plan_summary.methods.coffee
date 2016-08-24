#######################################
Meteor.methods
	update_plan_summary: (pid, data) ->
		db.plan_summary.update({"projectId": pid, "summaryOwner": Meteor.userId()}, {$set: data})


	#This is for completing a stage or updating the time of the current stage
	update_time_stage: (pid, stage, finishStage=false, reset_timeStarted=false) ->
		planSummary = db.plan_summary.findOne({"projectId": pid, "summaryOwner": Meteor.userId()})

		# If the time saved is more than 3 minutes, send a notification to the user
		if stage.time > 180000

			notificationData = {
				title: db.projects.findOne({_id: pid}).title
				time: stage.time
				stage: stage.name
			}

			syssrv.newNotification("time-registered", Meteor.userId(), notificationData)

		# the input stage is the stage that just had a new amount of time registered
		currentStage = _.findWhere planSummary.timeEstimated, {name: stage.name}
		currentStage.time = stage.time + currentStage.time

		if finishStage
			currentStage.finished = true

		data = {
			"timeEstimated": planSummary.timeEstimated
			"total.totalTime": planSummary.total.totalTime + stage.time
		}

		if reset_timeStarted
			data.timeStarted = "false"

		db.plan_summary.update({"projectId": pid}, {$set: data})


	update_timeStarted: (pid, timeStarted) ->
		db.plan_summary.update({"projectId": pid}, {$set: {"timeStarted": timeStarted}})


	add_time_stage: (projectId, stage_name, time) ->
		syssrv.modifyTime(projectId, stage_name, time, true)

	delete_time_stage: (projectId, stage_name, time) ->
		syssrv.modifyTime(projectId, stage_name, time, false)

#######################################