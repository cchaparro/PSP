##########################################
if Meteor.isServer
	syssrv.createPlanSummary = (userId, projectId, levelPSP) ->
		#Check if input parameters are the correct data type
		check(userId, String)
		check(projectId, String)
		check(levelPSP, String)

		#Bring initial default values for a new PlanSummary element
		timePlanSummary = Meteor.settings.public.timeEstimated[levelPSP]
		Injected = Meteor.settings.public.InjectedEstimated[levelPSP]
		Removed = Meteor.settings.public.RemovedEstimated[levelPSP]

		user = db.users.findOne({_id: Meteor.userId()}).profile
		historyTotalInjected = user.total.injected
		historyTotalRemoved = user.total.removed

		# This will add to the time the toDate and toDate% fields for the Plan Summary
		finalTime = _.filter timePlanSummary, (time) ->
			onDate = _.findWhere user.summaryAmount, {name: time.name}
			time.toDate = onDate.time
			time.percentage = 0
			time.estimated = 0
			return time

		finalInjected = _.filter Injected, (injected) ->
			onDate = _.findWhere user.summaryAmount, {name: injected.name}
			injected.toDate = onDate.injected
			if (onDate.injected == 0) or (historyTotalInjected == 0)
				injected.percentage = 0
			else
				injected.percentage = ((onDate.injected * 100) / historyTotalInjected).toFixed(2)
			return injected

		finalRemoved = _.filter Removed, (removed) ->
			onDate = _.findWhere user.summaryAmount, {name: removed.name}
			removed.toDate = onDate.removed
			if (onDate.removed == 0) or (historyTotalRemoved == 0)
				removed.percentage = 0
			else
				removed.percentage = ((onDate.removed * 100) / historyTotalRemoved).toFixed(2)
			return removed


		data = {
			summaryOwner: userId
			projectId: projectId
			timeEstimated: finalTime
			injectedEstimated: finalInjected
			removedEstimated: finalRemoved
			baseLOC: Meteor.settings.public.initialUserBaseLOC.baseSize
			addLOC: Meteor.settings.public.initialUserBaseLOC.addSize
			reusedLOC: Meteor.settings.public.initialUserBaseLOC.reusedSize
		}

		db.plan_summary.insert(data)


	syssrv.modifyTime = (projectId, stage_name, time, add_time) ->
		planSummary = db.plan_summary.findOne({"projectId": projectId})
		timeEstimated = planSummary?.timeEstimated
		currentStage = _.findWhere timeEstimated, {name: stage_name}

		if add_time
			currentStage.time += time
			planSummary.total.totalTime += time
		else
			if time >= currentStage.time
				planSummary.total.totalTime -= currentStage.time
				currentStage.time = 0
			else
				currentStage.time -= time
				planSummary.total.totalTime -= time
		actualProductivity = planSummary.total.productivityActual
		if planSummary.total.totalTime!= 0
			actualProductivity = parseInt((planSummary.total.actualAdd + planSummary.total.actualModified)/((planSummary.total.totalTime)/3600000))
		data = {
			"timeEstimated": timeEstimated
			"total.totalTime": planSummary.total.totalTime
			"total.productivityActual": actualProductivity
		}

		db.plan_summary.update({"projectId": projectId}, {$set: data})

	#This is used to update the time registered in a stage of a project
	syssrv.updateTimeStage = (projectId, stage, finishStage, reset_timeStarted) ->
		planSummary = db.plan_summary.findOne({"projectId": projectId, "summaryOwner": Meteor.userId()})

		# If the time saved is more than 3 minutes, send a notification to the user
		if stage.time > 180000
			notificationData = {
				title: db.projects.findOne({_id: projectId}).title
				time: stage.time
				stage: stage.name
				id: planSummary._id
			}
			syssrv.newNotification("time-registered", Meteor.userId(), notificationData)

		# the input stage is the stage that just had a new amount of time registered
		currentStage = _.findWhere planSummary.timeEstimated, {name: stage.name}
		currentStage.time = stage.time + currentStage.time

		actualProductivity = 0

		if finishStage
			currentStage.finished = true
		if planSummary.total.totalTime + stage.time != 0
			actualProductivity = parseInt((planSummary.total.actualAdd + planSummary.total.actualModified)/((planSummary.total.totalTime + stage.time)/3600000))

		data = {
			"timeEstimated": planSummary.timeEstimated
			"total.totalTime": planSummary.total.totalTime + stage.time
			"total.productivityActual": actualProductivity
		}

		if reset_timeStarted
			data.timeStarted = "false"

		db.plan_summary.update({"projectId": projectId}, {$set: data})


	#Used to update each stage of a projects porcentage (which is displayed in the planSummary)
	syssrv.updateStagesPercentage = (projectId)->
		planSummary = db.plan_summary.findOne({"projectId": projectId, "summaryOwner": Meteor.userId()})
		totalTime = planSummary.total.totalTime
		stages = planSummary.timeEstimated

		_.each stages, (stage)->
			stage.percentage = parseInt((stage.time*100)/totalTime)

		db.plan_summary.update({ "projectId":projectId }, {$set: "timeEstimated": stages })


##########################################