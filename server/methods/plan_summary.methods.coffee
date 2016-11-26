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
		check(projectId, String)
		check(stage, Object)
		check(finishStage, Boolean)
		check(reset_timeStarted, Boolean)

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

		#This updates all the project stages percentages
		syssrv.update_stages_percentage(projectId)
		db.plan_summary.update({"projectId": projectId}, {$set: data})


	# This is used to change the finished field of a projects stage between true/false
	update_stage_completed_value: (projectId, stage) ->
		planSummary = db.plan_summary.findOne({"projectId": projectId, "summaryOwner": Meteor.userId()})
		projectStages = planSummary?.timeEstimated

		currentStage = _.findWhere projectStages, {name: stage.name}
		currentStage.finished = !stage.finished

		db.plan_summary.update({"projectId": projectId}, {$set: { "timeEstimated": projectStages }})


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
		totalEstimatedAdd			= 0
		totalActualAdd				= 0
		totalSize					= 0
		totalEstimatedSize		= 0
		proxySize					= 0
		actualProductivity		= 0
		_.each baseData, (baseOption)->
			totalEstimatedBase		+= parseInt(baseOption.Estimated.base)
			totalActualBase			+= parseInt(baseOption.Actual.base)
			totalEstimatedAdd			+= parseInt(baseOption.Estimated.add)
			totalActualAdd				+= parseInt(baseOption.Actual.add)
			totalEstimatedModified	+= parseInt(baseOption.Estimated.modified)
			totalActualModified		+= parseInt(baseOption.Actual.modified)

			totalEstimatedDeleted	+= parseInt(baseOption.Estimated.deleted)
			totalActualDeleted		+= parseInt(baseOption.Actual.deleted)


		addData = planSummary.addLOC
		_.each addData, (addOption)->
			totalEstimatedAdd	+= parseInt(addOption.Estimated.size)
			totalActualAdd		+= parseInt(addOption.Actual.size)
		
		proxySize = totalEstimatedAdd + totalEstimatedModified
		totalNewSize = totalActualAdd + totalActualBase - totalActualDeleted + planSummary.total.actualReused

		totalEstimatedSize = planSummary.total.estimatedAddedSize - totalEstimatedModified - totalEstimatedDeleted + totalEstimatedBase + planSummary.total.estimatedReused
		
		projectTotalTime = sys.timeToHours(planSummary.total.totalTime)

		if projectTotalTime >= 1
			actualProductivity = parseInt((totalActualAdd + totalActualModified) / projectTotalTime)
		else
			actualProductivity = planSummary.total.productivityActual

		newtotal = {
			totalTime:					planSummary.total.totalTime
			totalSize:					totalNewSize
			estimatedTotalSize:		totalEstimatedSize
			estimatedTime:				planSummary.total.estimatedTime
			estimatedBase:				totalEstimatedBase
			actualBase:					totalActualBase
			estimatedAdd:				totalEstimatedAdd
			actualAdd:					totalActualAdd
			estimatedModified:		totalEstimatedModified
			actualModified:			totalActualModified
			estimatedDeleted:			totalEstimatedDeleted
			actualDeleted:				totalActualDeleted
			estimatedReused:			planSummary.total.estimatedReused
			actualReused:				planSummary.total.actualReused
			proxyEstimated:			proxySize
			estimatedAddedSize:		planSummary.total.estimatedAddedSize
			productivityPlan:			planSummary.total.productivityPlan
			productivityActual:			actualProductivity
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
		totalEstimatedSize = 0
		totalNewSize = 0
		_.each addData, (addOption) ->
			totalEstimatedAdd += parseInt(addOption.Estimated.size)
			totalActualAdd += parseInt(addOption.Actual.size)

		baseData = planSummary.baseLOC
		_.each baseData, (baseOption)->
			totalEstimatedAdd += parseInt(baseOption.Estimated.add)
			totalActualAdd += parseInt(baseOption.Actual.add)
			totalEstimatedModified += parseInt(baseOption.Estimated.modified)
		proxySize	= totalEstimatedAdd + totalEstimatedModified
		
		totalNewSize	= totalActualAdd + planSummary.total.actualBase - planSummary.total.actualDeleted + planSummary.total.actualReused

		totalEstimatedSize	= planSummary.estimatedAddedSize - totalEstimatedModified - planSummary.total.estimatedDeleted + planSummary.total.estimatedBase + planSummary.total.estimatedReused

		totalActualModified = planSummary.total.actualModified
		timeHours = sys.timeToHours(planSummary.total.totalTime)

		if timeHours >= 1
			actualProductivity = parseInt((totalActualAdd + totalActualModified)/timeHours)
		else
			actualProductivity = planSummary.total.productivityActual

		data = {
			"addLOC": addData
			"total.estimatedAdd": totalEstimatedAdd
			"total.actualAdd": totalActualAdd
			"total.proxyEstimated": proxySize
			"total.totalSize": totalNewSize
			"total.productivityActual": actualProductivity
		}

		db.plan_summary.update({ "projectId":projectId }, { $set: data })


	update_reused_size: (projectId, reusedData) ->
		planSummary = db.plan_summary.findOne({ "projectId":projectId })
		totalRuActual = 0
		totalRuEstimated = 0
		totalEstimatedSize = 0
		totalNewSize = 0

		_.each reusedData, (reusedOption) ->
			totalRuActual 				+= parseInt(reusedOption.Actual.size)
			totalRuEstimated 			+= parseInt(reusedOption.Estimated.size)

		totalNewSize	= planSummary.total.actualAdd + planSummary.total.actualBase - planSummary.total.actualDeleted + totalRuActual
		
		totalEstimatedSize	= planSummary.total.estimatedAddedSize - planSummary.total.estimatedModified - planSummary.total.estimatedDeleted + planSummary.total.estimatedBase + totalRuEstimated

		data = {
			"reusedLOC": reusedData
			"total.estimatedReused":totalRuEstimated
			"total.actualReused":totalRuActual
			"total.totalSize":totalNewSize
			"total.estimatedTotalSize":totalEstimatedSize
		}

		db.plan_summary.update({ "projectId":projectId }, {$set: data })


	update_stages_percentage: (projectId)->
		check(projectId, String)

		planSummary = db.plan_summary.findOne({"projectId": projectId, "summaryOwner": Meteor.userId()})
		totalTime = planSummary.total.totalTime
		stages = planSummary.timeEstimated

		_.each stages, (stage)->
			stage.percentage = parseInt((stage.time*100)/totalTime)

		db.plan_summary.update({ "projectId":projectId }, {$set: "timeEstimated": stages })


	update_estimated: (projectId)->
		actualProject = db.projects.findOne({_id:projectId})
		planSummary = db.plan_summary.findOne({"projectId":projectId,"summaryOwner": Meteor.userId()})
		stages = planSummary.timeEstimated
		lastFinishedProject = db.projects.findOne({"projectOwner": Meteor.userId(), "completed": true,"levelPSP":actualProject.levelPSP}, {sort: {createdAt: -1}})
		if lastFinishedProject
			planSummaryLastProject = db.plan_summary.findOne({"projectId":lastFinishedProject._id,"summaryOwner": Meteor.userId()})
			totalTime = planSummary.total.estimatedTime
			_.each stages,(stage)->
				lastProjectStage = _.findWhere planSummaryLastProject.timeEstimated, {name: stage.name}
				stage.estimated = parseInt((lastProjectStage.percentage/100) * totalTime)
		else
			_.each stages,(stage)->
				stage.estimated = 0

		data = {
				"timeEstimated": stages
			}
		db.plan_summary.update({ "projectId": projectId }, {$set: data })


	update_plan_summary_size_psp0: (projectId, field,value) ->
		data = {}
		value = parseInt(value)
		total = 0
		planSummary = db.plan_summary.findOne({"projectId":projectId,"summaryOwner": Meteor.userId()})		
		switch field
			when "actualBase"
				total = value + planSummary.total.actualAdd + planSummary.total.actualReused - planSummary.total.actualDeleted
				data = {
					"total.actualBase":value
					"total.total.totalSize":total
				}
			when "actualAdd"
				total = value + planSummary.total.actualBase + planSummary.total.actualReused - planSummary.total.actualDeleted
				data = {
					"total.actualAdd":value
					"total.totalSize":total
				}
			when "actualDeleted"
				total = planSummary.total.actualBase + planSummary.total.actualAdd + planSummary.total.actualReused - value
				data = {
					"total.actualDeleted":value
					"total.totalSize":total
				}
			when "actualModified"
				data = {
					"total.actualModified":value
				}
			when "actualReused"
				total = planSummary.total.actualBase + planSummary.total.actualAdd + planSummary.total.actualDeleted + value

				data = {
					"total.actualReused":value
					"total.totalSize":total
				}
		db.plan_summary.update({"projectId": projectId, "summaryOwner": Meteor.userId()}, {$set: data})
#######################################