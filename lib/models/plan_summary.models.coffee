summaryValues = (element, data) ->
	# This will add to the time the toDate and toDate% fields for the Plan Summary
	user = db.users.findOne({_id: Meteor.userId()}).profile

	result = _.filter data, (field) ->
		currentStage = _.findWhere user.summaryAmount, {name: field.name}
		field.toDate = currentStage[element]

		#This can be totalInjected or totalRemoved
		#historyTotal = user.total[element]

		switch element
			when "time"
				field.percentage = 0
				field.estimated = 0
			when "injected", "removed"
				field.percentage = 0
		return field

	return result

##########################################
if Meteor.isServer
	syssrv.createPlanSummary = (userId, projectId, levelPSP) ->
		#Bring initial default values for a new PlanSummary element
		Time = Meteor.settings.public.timeEstimated[levelPSP]
		Injected = Meteor.settings.public.InjectedEstimated[levelPSP]
		Removed = Meteor.settings.public.RemovedEstimated[levelPSP]

		data = {
			summaryOwner: userId
			projectId: projectId
			timeEstimated: summaryValues("time", Time)
			injectedEstimated: summaryValues("injected", Injected)
			removedEstimated: summaryValues("removed", Removed)
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
	syssrv.updateStagesPercentage = (projectId) ->
		planSummary = db.plan_summary.findOne({"projectId": projectId, "summaryOwner": Meteor.userId()})
		totalTime = planSummary.total.totalTime
		stages = planSummary.timeEstimated

		#If totalTime is zero then the percentage value would get a arithmetic error
		if totalTime == 0
			return

		_.each stages, (stage)->
			stage.percentage = parseInt((stage.time*100)/totalTime)

		db.plan_summary.update({ "projectId":projectId }, {$set: "timeEstimated": stages })


	#Used to update each stage of a projects defects porcentage (which is displayed in the planSummary)
	syssrv.updateDefectsPercentage = (projectId) ->
		planSummary = db.plan_summary.findOne({"projectId": projectId, "summaryOwner": Meteor.userId()})
		totalInjected = planSummary.total.totalInjected
		totalRemoved = planSummary.total.totalRemoved
		stagesInjected = planSummary.injectedEstimated
		stagesRemoved = planSummary.removedEstimated

		if totalInjected == 0 or totalRemoved == 0
			return

		_.each stagesInjected, (stage)->
			stage.percentage = parseInt((stage.injected*100)/totalInjected)

		_.each stagesRemoved, (stage)->
			stage.percentage = parseInt(((stage.removed*100)/totalRemoved))

		data = {
			"injectedEstimated": stagesInjected
			"removedEstimated": stagesRemoved
		}

		db.plan_summary.update({ "projectId": projectId }, {$set: data })

##########################################