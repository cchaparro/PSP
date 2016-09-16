#######################################
Meteor.methods
	update_plan_summary: (projectId, data) ->
		db.plan_summary.update({"projectId": projectId, "summaryOwner": Meteor.userId()}, {$set: data})

		#planSummary = db.plan_summary.findOne({ "projectId":pid })

		#_.each planSummary.timeEstimated, (stage)->
		#	if stage.name == "Planeación" or stage.name == "Postmortem" or stage.name == "Compilación"
		#		stage.estimated = planSummary.total.estimatedTime * 0.05
		#	else if stage.name == "Código"
		#		stage.estimated = planSummary.total.estimatedTime * 0.5
		#	else if stage.name == "Diseño"
		#		stage.estimated = planSummary.total.estimatedTime * 0.25
		#	else
		#		stage.estimated = planSummary.total.estimatedTime * 0.1

		#newData = {
		#	timeEstimated: planSummary.timeEstimated
		#}

		#db.plan_summary.update({ "projectId":pid }, { $set: newData })



	#This is for completing a stage or updating the time of the current stage
	update_time_stage: (projectId, stage, finishStage=false, reset_timeStarted=false) ->
		planSummary = db.plan_summary.findOne({"projectId": projectId, "summaryOwner": Meteor.userId()})

		# If the time saved is more than 3 minutes, send a notification to the user
		if stage.time > 180000

			notificationData = {
				title: db.projects.findOne({_id: projectId}).title
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

		db.plan_summary.update({"projectId": projectId}, {$set: data})


	update_timeStarted: (projectId, timeStarted) ->
		db.plan_summary.update({"projectId": projectId}, {$set: {"timeStarted": timeStarted}})

	add_time_stage: (projectId, stage_name, time) ->
		syssrv.modifyTime(projectId, stage_name, time, true)

	delete_time_stage: (projectId, stage_name, time) ->
		syssrv.modifyTime(projectId, stage_name, time, false)


	update_base_size: (projectId, baseData) ->
		planSummary = db.plan_summary.findOne({ "projectId":projectId })
		totalEstimatedBase		= 0
		totalActualBase			= 0
		totalEstimatedDeleted	= 0
		totalActualDeleted		= 0
		totalEstimatedModified	= 0
		totalActualModified		= 0
		totalEstimatedAdd		= 0
		totalActualAdd			= 0
		totalSize				= 0
		proxySize				= 0
		_.each baseData, (baseOption)->
			totalEstimatedBase		+= parseInt(baseOption.Estimated.base)
			totalActualBase			+= parseInt(baseOption.Actual.base)
			totalEstimatedAdd		+= parseInt(baseOption.Estimated.add)
			totalActualAdd			+= parseInt(baseOption.Actual.add)
			totalEstimatedModified	+= parseInt(baseOption.Estimated.modified)
			totalActualModified		+= parseInt(baseOption.Actual.modified)

			totalEstimatedDeleted	+= parseInt(baseOption.Estimated.deleted)
			totalActualDeleted		+= parseInt(baseOption.Actual.deleted)


		addData = planSummary.addLOC
		_.each addData, (addOption)->
			totalEstimatedAdd	+= parseInt(addOption.Estimated.size)
			totalActualAdd		+= parseInt(addOption.Actual.size)
		proxySize	= totalEstimatedAdd + totalEstimatedModified
		totalNewSize	= totalActualAdd + totalActualBase - totalActualDeleted
		newtotal = {
			totalTime:					planSummary.total.totalTime
			totalSize:					totalNewSize
			estimatedTime:				planSummary.total.estimatedTime
			estimatedBase:				totalEstimatedBase
			actualBase:					totalActualBase
			estimatedAdd:				totalEstimatedAdd
			actualAdd:					totalActualAdd
			estimatedModified:			totalEstimatedModified
			actualModified:				totalActualModified
			estimatedDeleted:			totalEstimatedDeleted
			actualDeleted:				totalActualDeleted
			estimatedReused:			planSummary.total.estimatedReused
			actualReused:				planSummary.total.actualReused
			proxyEstimated:				proxySize
			estimatedAddedSize:			planSummary.total.estimatedAddedSize
		}

		data = {
			"baseLOC": baseData
			"total":newtotal
		}

		db.plan_summary.update({ "projectId": projectId }, { $set: data })


	update_add_size: (projectId, addData) ->
		planSummary = db.plan_summary.findOne({ "projectId":projectId })
		totalEstimatedAdd = 0
		totalActualAdd = 0
		totalEstimatedModified = 0
		_.each addData, (addOption) ->
			totalEstimatedAdd += parseInt(addOption.Estimated.size)
			totalActualAdd += parseInt(addOption.Actual.size)

		baseData = planSummary.baseLOC
		_.each baseData, (baseOption)->
			totalEstimatedAdd += parseInt(baseOption.Estimated.add)
			totalActualAdd += parseInt(baseOption.Actual.add)
			totalEstimatedModified += parseInt(baseOption.Estimated.modified)
		proxySize	= totalEstimatedAdd + totalEstimatedModified
		totalNewSize	= totalActualAdd + planSummary.total.actualBase - planSummary.total.actualDeleted
		data = {
			"addLOC": addData
			"total.estimatedAdd": totalEstimatedAdd
			"total.actualAdd": totalActualAdd
			"total.proxyEstimated": proxySize
			"total.totalSize":totalNewSize
		}

		db.plan_summary.update({ "projectId":projectId }, { $set: data })


	update_reused_size: (projectId, reusedData) ->
		totalRuActual = 0
		totalRuEstimated = 0

		_.each reusedData, (reusedOption) ->
			totalRuActual 				+= parseInt(reusedOption.Actual.size)
			totalRuEstimated 			+= parseInt(reusedOption.Estimated.size)

		data = {
			"reusedLOC": reusedData
			"total.estimatedReused":totalRuEstimated
			"total.actualReused":totalRuActual
		}

		db.plan_summary.update({ "projectId":projectId }, {$set: data })

#######################################